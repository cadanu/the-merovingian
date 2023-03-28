//
//  FormViewController.swift
//  TheMerovingian
//
//  Created by GDJ on 2023-03-26.
//

import UIKit

class FormViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    // not mandatory - will be remembered by user defaults
    // add to UserInfo table later
    @IBOutlet var tfCity: UITextField!
    @IBOutlet var tfRegion: UITextField!
    @IBOutlet var tfPostCode: UITextField!
    @IBOutlet var tfCountry: UITextField!
    @IBOutlet var tfPhone: UITextField!
    @IBOutlet var gender: UISwitch!
    @IBOutlet var slide: UISlider!// age slider
    @IBOutlet var slideValue: UILabel!// age value
    @IBOutlet var dob: UIDatePicker!
    // mandatory fields
    @IBOutlet var tfName: UITextField!
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var pickerImageView: UIImageView!
    var avatarSelected: String?// remembers string for picker image
    // for display message
    var alertTitle: String?
    var alertMessage: String?
    // for show mandatory fields after submit error
    let red = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.3)
    let clearColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    @IBOutlet weak var backButtonOutlet: UIBarButtonItem!
    
    
    // picker view methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        mainDelegate.avatarArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        avatarSelected = mainDelegate.avatarArray[row]
        return mainDelegate.avatarArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        avatarSelected = mainDelegate.avatarArray[row]
        let pickerImage = UIImage(named: avatarSelected!)// wrap asset in UIImage
        pickerImageView.image = pickerImage// wrap UIImage in UIImageView
        pickerImageView.backgroundColor = clearColor
    }
    
    // initialize slider
    func sliderSettings(_ sender: UISlider) {
        sender.minimumValue = 0
        sender.maximumValue = 100
        sender.value = 50
    }
    
    // doTheUpdate runs when the Submit button is pressed
    func doTheUpdate() {
        // avatar choice (avatarSelected) is being stored in city for the time being
        let data: User = .init()
        data.initWithData(theName: tfName.text!, theEmail: tfEmail.text!, theCity: avatarSelected!)
        
        print("Before if: \(String(describing: data.name)) | \(String(describing: data.email)) | \(String(describing: data.city))")
        
        if (data.name?.isEmpty == false) && (data.email?.isEmpty == false) && (data.city?.isEmpty == false) {
            
            if mainDelegate.insertIntoDatabase(user: data) {
                alertTitle = "Submission Successful"
                alertMessage = "Thankyou for signing up " + data.name!
                + " of " + data.email!
                print("User information was saved.")
            }
            else {
                alertTitle = "Error"
                alertMessage = "This email address is already registered."
                print("User information wasn't saved.")
            }
        }
        else {
            alertTitle = "Error"
            alertMessage = "Mandatory fields not filled."
            tfName.backgroundColor = red
            tfEmail.backgroundColor = red
            pickerImageView.backgroundColor = red
            print("User information wasn't filled in.")
        }
    }
    
    // Submit
    @IBAction func SubmitForm(sender : Any) {
        doTheUpdate()
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
    
    
    // set UserDefaults
    func rememberUserData() {
        print("rememberUserData")
        
        let defaults = UserDefaults.standard
        
        defaults.set(tfName.text, forKey: "lastName")
        defaults.set(tfEmail.text, forKey: "lastEmail")
        defaults.set(tfCity.text, forKey: "lastCity")
        defaults.set(tfRegion.text, forKey: "lastRegion")
        defaults.set(tfPostCode.text, forKey: "lastPostCode")
        defaults.set(tfCountry.text, forKey: "lastCountry")
        defaults.set(tfPhone.text, forKey: "lastPhone")
        defaults.set(gender.isOn, forKey: "lastGender")
        defaults.set(slide.value, forKey: "lastSlidePosition")
        defaults.set(slideValue.text, forKey: "lastSlideValue")
        defaults.set(dob.date, forKey: "lastDob")
        // waits for any pending async updates
        defaults.synchronize()
    }
    
    // handle keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        rememberUserData()
        return textField.resignFirstResponder()// handles keyboard
    }

    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderSettings(slide)
        slideValue.text = "50"
        slide.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
        tfName.addTarget(self, action: #selector(textFieldValueChanged(sender:)), for: .editingChanged)
        tfEmail.addTarget(self, action: #selector(textFieldValueChanged(sender:)), for: .editingChanged)
        
        // handle defaults
        let defaults = UserDefaults.standard
        if let name = defaults.object(forKey: "lastName") as? String {
            tfName.text = name
        }
        if let email = defaults.object(forKey: "lastEmail") as? String {
            tfEmail.text = email
        }
        if let city = defaults.object(forKey: "lastCity") as? String {
            tfCity.text = city
        }
        if let region = defaults.object(forKey: "lastRegion") as? String {
            tfRegion.text = region
        }
        if let postal = defaults.object(forKey: "lastPostCode") as? String {
            tfPostCode.text = postal
        }
        if let country = defaults.object(forKey: "lastCountry") as? String {
            tfCountry.text = country
        }
        if let phone = defaults.object(forKey: "lastPhone") as? String {
            tfPhone.text = phone
        }
        if let gen = defaults.object(forKey: "lastGender") as? Bool {
            gender.isOn = gen
        }
        if let slid = defaults.object(forKey: "lastSlidePosition") as? Float {
            slide.value = slid
            slideValue.text = String(format: "%.0f", slid)
        }
        if let dobDef = defaults.object(forKey: "lastDob") as? Date {
            dob.date = dobDef
        }
    }
    
    @objc func sliderValueChanged(sender: UISlider) {
        slideValue.text = String(format: "%.0f", sender.value)
    }
    
    @objc func textFieldValueChanged(sender: UITextField) {
        sender.backgroundColor = clearColor
    }

}
