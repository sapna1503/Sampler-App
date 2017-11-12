//  SecondViewController.swift
//  Sampler
//
//  Created by Sapna Chandiramani.
//  Copyright © 2017 Sapna Chandiramani. All rights reserved.
//

import UIKit
import MapKit

class SecondViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var fromResultSearchController: UISearchController!
    var sourceString : String = ""
    var destinationString : String = ""
    var srcPlaceMark : MKPlacemark!
    var destPlaceMark : MKPlacemark!
    var locationTableView : LocationTableView?
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        showAnnotations()
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true

        locationManager.requestAlwaysAuthorization()
        
        locationTableView = storyboard!.instantiateViewController(withIdentifier: "LocationTableView") as? LocationTableView
        fromResultSearchController = UISearchController(searchResultsController: locationTableView)
        fromResultSearchController.searchResultsUpdater = locationTableView
        
        let searchBarFrom = fromResultSearchController!.searchBar
        searchBarFrom.sizeToFit()
        searchBarFrom.placeholder = "Search From"
        
        navigationItem.titleView = fromResultSearchController?.searchBar
        fromResultSearchController.hidesNavigationBarDuringPresentation = false
        fromResultSearchController.dimsBackgroundDuringPresentation = true
        
        definesPresentationContext = true
        locationTableView?.mapView = mapView
        locationTableView?.handleMapSearchDelegate = self
        locationTableView?.setSourceAddress(nil)
        locationTableView?.setDestinationAddress(nil)
    }

    func showAnnotations()
    {
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.90, 0.90)
        let annotation = MKPointAnnotation()
        let firstLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(32.793378, -116.958882)
        annotation.coordinate = firstLocation
        annotation.title = "El Cajon"
        self.mapView.addAnnotation(annotation)
        
        let secondAnnotation = MKPointAnnotation()
        let secondLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(33.119755, -117.088863)
        secondAnnotation.coordinate = secondLocation
        secondAnnotation.title = "Escondido"
        self.mapView.addAnnotation(secondAnnotation)

        
        let region: MKCoordinateRegion = MKCoordinateRegionMake(firstLocation, span)
        self.mapView.setRegion(region, animated: true)
        mapView.setCenter(CLLocationCoordinate2D(latitude: 32.716851, longitude: -117.146098), animated: true)
    }

    func setSourcePlaceMaker(_ source : String, placeMark : MKPlacemark) {
        self.sourceString = source
        self.srcPlaceMark = placeMark
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        let annotation = MKPointAnnotation()
        annotation.coordinate = srcPlaceMark.coordinate
        annotation.title = sourceString
        self.mapView.addAnnotation(annotation)
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.90, 0.90)
        
        let region: MKCoordinateRegion = MKCoordinateRegionMake(srcPlaceMark.coordinate, span)
        self.mapView.setRegion(region, animated: true)
        
        fromResultSearchController!.searchBar.text = ""
        fromResultSearchController!.searchBar.placeholder = "Search To"
        locationTableView?.setDestinationAddress(nil)
    }
    
    func setDestinationPlaceMaker(_ destination : String, placeMark : MKPlacemark) {
        self.destinationString = destination
        self.destPlaceMark = placeMark
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = destPlaceMark.coordinate
        annotation.title = destinationString
        self.mapView.addAnnotation(annotation)
        
        fromResultSearchController!.searchBar.text = ""
        fromResultSearchController!.searchBar.placeholder = "Search From"
        locationTableView?.setSourceAddress(nil)
        locationTableView?.provideDirections(source: sourceString, destination: destinationString)        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SecondViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
}

