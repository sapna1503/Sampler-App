//  FirstViewController.swift
//  Sampler
//
//  Created by Sapna Chandiramani.
//  Copyright © 2017 Sapna Chandiramani. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var sportsSlider: UISlider!

    var countryAndSports: Dictionary<String, Array<String>>?
    var countryType: Array<String>?
    var selectedCountry: String?
    var sports: Array<String>?

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self

        let data: Bundle = Bundle.main
        let sportsPlist: String? = data.path(forResource: "Sports", ofType: "plist")
        if sportsPlist != nil {
            countryAndSports = (NSDictionary.init(contentsOfFile: sportsPlist!) as! Dictionary)
            countryType = countryAndSports?.keys.sorted()
            selectedCountry = countryType![0]
            sports = countryAndSports![selectedCountry!]!.sorted()
        }
        self.sportsSlider.value = 0.0
        self.sportsSlider.maximumValue = Float(self.sports!.count - 1)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard (countryType != nil) && (sports != nil) else { return 0 }

        switch component {
            case 0: return countryType!.count
            case 1: return sports!.count
            default: return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard(countryType != nil) && (sports != nil)else { return "None" }
        switch component {
            case 0: return countryType![row]
            case 1: return sports![row]
            default: return "None"
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard(countryType != nil) && (sports != nil)else { return }
        self.sportsSlider.value = 0.0

        guard(component == 0) else {
            self.sportsSlider.value = Float(row)
            return
        }
        selectedCountry = countryType![row]
        sports = countryAndSports![selectedCountry!]!.sorted()
        self.sportsSlider.maximumValue = (Float((sports?.count)!) - 1.0)
        pickerView.selectRow(component, inComponent: 1, animated: true)
        pickerView.reloadComponent(1)
        self.sportsSlider.maximumValue = Float((sports?.count)! - 1)
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel
        if let label = view as? UILabel { pickerLabel = label }
        else
        {
            pickerLabel = UILabel()
            pickerLabel.textColor = UIColor.black
            pickerLabel.textAlignment = NSTextAlignment.center
        }
        pickerLabel.sizeToFit()

        switch component {
            case 0: pickerLabel.text = countryType![row]
            case 1: pickerLabel.text = sports![row]
            default: pickerLabel.text = "None"
        }
        return pickerLabel
    }

    @IBAction func sportsSliderValuechanged(_ sender: UISlider) {
        let roundedFloatValue: Int = Int(roundf(self.sportsSlider.value))
        pickerView.selectRow(roundedFloatValue, inComponent: 1, animated: true)
        pickerView.reloadComponent(1)
    }

    @IBAction func sportsSliderFinishedSliding(_ sender: Any) {
        self.sportsSlider.value = roundf(self.sportsSlider.value)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

