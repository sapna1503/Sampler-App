//  LocationTableView.swift
//  Sampler
//
//  Created by Sapna Chandiramani.
//  Copyright © 2017 Sapna Chandiramani. All rights reserved.
//

import UIKit
import MapKit

class LocationTableView: UITableViewController {
    
    var handleMapSearchDelegate: SecondViewController?
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView?
    var selectedSourceAddress: String? = nil
    var selectedDestinationAddress: String? = nil

    func parseAddress(_ selectedItem: MKPlacemark) -> String {
        let spaceBetweenPlace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        
        let commaBetweenCity = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        
        let spaceBetweenLocality = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        
        let addressLine = String(format: "%@%@%@%@%@%@%@",selectedItem.subThoroughfare ?? "",spaceBetweenPlace,selectedItem.thoroughfare ?? "",commaBetweenCity,selectedItem.locality ?? "",spaceBetweenLocality,selectedItem.administrativeArea ?? "")

        return addressLine
    }

    func setSourceAddress(_ source: String?) {
        selectedSourceAddress = source
    }

    func setDestinationAddress(_ destination: String?) {
        selectedDestinationAddress = destination
    }
}

extension LocationTableView: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
        let searchBarText = searchController.searchBar.text else { return }

        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)

        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}

extension LocationTableView {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[(indexPath as NSIndexPath).row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        dismiss(animated: true, completion: nil)
        if selectedSourceAddress == nil {
            self.selectedSourceAddress = selectedItem.title!
            handleMapSearchDelegate!.setSourcePlaceMaker(selectedItem.title!, placeMark: selectedItem)
        }
        else {
            self.selectedDestinationAddress = selectedItem.title!
            handleMapSearchDelegate!.setDestinationPlaceMaker(selectedItem.title!, placeMark: selectedItem)
        }
    }

    func provideDirections(source: String, destination: String) {
        let request = MKDirectionsRequest()
        CLGeocoder().geocodeAddressString(source, completionHandler: { placemarks, error in
            guard let placemarks = placemarks else { return }
            let placemark = placemarks[0]
            let sourceCoordinates = placemark.location!.coordinate
            let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinates, addressDictionary: nil)
            let sourceItem = MKMapItem(placemark: sourcePlacemark)
            sourceItem.name = source
            request.source = sourceItem
        })

        CLGeocoder().geocodeAddressString(destination, completionHandler: { placemarks, error in
            guard let placemarks = placemarks else { return }
            let placemark = placemarks[0]
            let destinationCoordinates = placemark.location!.coordinate
            let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinates, addressDictionary: nil)

            let destinationItem = MKMapItem(placemark: destinationPlacemark)
            destinationItem.name = destination
            request.destination = destinationItem
            request.transportType = .automobile
            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                guard let response = response else { return }
                let route = response.routes[0]
                self.mapView?.add(route.polyline, level: .aboveRoads)
                let rect = route.polyline.boundingMapRect
                self.mapView?.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            }
        })
    }
}

