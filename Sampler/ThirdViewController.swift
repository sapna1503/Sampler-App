//  ThirdViewController.swift
//  Sampler
//
//  Created by Sapna Chandiramani on 10/19/17.
//  Copyright © 2017 Sapna Chandiramani. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var switchOnOff: UISwitch!
    @IBOutlet weak var btnShowAlert: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewSelected(selectedSegmentIndex: 0)
    }
    
    @IBAction func onSegmentedControlValueChanged(_ sender: Any) {
        viewSelected(selectedSegmentIndex: segmentedControl.selectedSegmentIndex)
    }

    func viewSelected(selectedSegmentIndex: Int) {
        switch selectedSegmentIndex {
            case 0:
                activityIndicator.isHidden = false
                switchOnOff.isHidden = false
                textView.isHidden = true
                btnShowAlert.isHidden = true
            case 1:
                textView.isHidden = false
                activityIndicator.isHidden = true
                switchOnOff.isHidden = true
                btnShowAlert.isHidden = true
            case 2:
                btnShowAlert.isHidden = false
                activityIndicator.isHidden = true
                switchOnOff.isHidden = true
                textView.isHidden = true
            default: return
        }
    }

    @IBAction func changeActivityIndicator(_ sender: Any) {
        guard(switchOnOff.isOn) else {
            activityIndicator.stopAnimating()
            return
        }
        activityIndicator.startAnimating()
    }
    
    
    @IBAction func showAlertOnButtonClick(_ sender: UIButton) {
        showAlert(title: "Alert", message: "Do you like the iPhone?")
    }
    
    func showAlert(title :String , message : String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert,animated: true,completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


