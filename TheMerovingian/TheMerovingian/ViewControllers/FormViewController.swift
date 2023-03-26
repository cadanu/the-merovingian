//
//  FormViewController.swift
//  TheMerovingian
//
//  Created by GDJ on 2023-03-26.
//

import UIKit

class FormViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var tfName : UITextField!
    @IBOutlet var tfEmail : UITextField!
    
    @IBOutlet var slide : UISlider!
    @IBOutlet var slideValue : UILabel!
    
    var alertTitle : String?
    var alertMessage : String?
    
    func sliderSettings(_ sender: UISlider) {
        sender.minimumValue = 0
        sender.maximumValue = 100
        sender.value = 50
    }
    
    @objc func sliderValueChanged(sender: UISlider) {
        slideValue.text = String(format: "%.0f", sender.value)
    }
    
    func doTheUpdate() {
        let data : Data = .init()
        data.initWithData(theName: tfName.text!, theEmail: tfEmail.text!)
        
        if (data.savedName?.isEmpty == false) && (data.savedEmail?.isEmpty == false) {
            alertTitle = "Submission Successful"
            alertMessage = "Thankyou for signing up " + data.savedName!
                            + " of " + data.savedEmail!
        }
        else {
            alertTitle = "Error"
            alertMessage = "Mandatory fields not filled"
        }
    }
    
    @IBAction func SubmitForm(sender : Any) {
        doTheUpdate()
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sliderSettings(slide)
        slide.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
    }

}
