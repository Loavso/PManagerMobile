//
//  AddViolationViewController.swift
//  PManager
//
//  Created by Lauryn Landkrohn on 4/18/20.
//  Copyright © 2020 Lauryn Landkrohn. All rights reserved.
//

import UIKit

class AddViolationViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var violationPicker: UIPickerView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var pickerTextField: UITextField!
    @IBOutlet weak var violationPickerTextField: UITextField!
    @IBOutlet weak var plateImageView: UIImageView!
    @IBOutlet weak var licensePlateField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    var locationPickerData: [String] = []
    var violationPickerData: [String] = []
    
    override func viewDidLoad() {
        picker.isHidden = true;
        super.viewDidLoad()
        
        picker.isHidden = true
        violationPicker.isHidden = true
        
        plateImageView.clipsToBounds = true
        plateImageView.contentMode = .scaleAspectFit
        
        ClientsAPI.enumsGet() { data, error in
            self.locationPickerData = data?.locations as! [String]
            self.violationPickerData = data?.violations as! [String]
            self.violationPickerTextField.text = self.violationPickerData[0]
            self.pickerTextField.text = self.locationPickerData[0]
            [self.violationPicker .reloadAllComponents()]
            [self.picker .reloadAllComponents()]
        }
        
        self.violationPickerTextField.delegate = self
        self.violationPicker.delegate = self
        self.violationPicker.dataSource = self
        
        self.pickerTextField.delegate = self
        self.picker.delegate = self
        self.picker.dataSource = self
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        plateImageView.isUserInteractionEnabled = true
        plateImageView.addGestureRecognizer(singleTap)
    }
    
    @IBAction func DoCreateViolation(_ sender: Any) {
        if(!(descriptionField.text!).isEmpty &&
        !(pickerTextField.text!).isEmpty &&
        !(violationPickerTextField.text!).isEmpty &&
        !(licensePlateField.text!).isEmpty)
        {
            createViolation(plate: licensePlateField.text!, violation: violationPickerTextField.text!, location: pickerTextField.text!, description: descriptionField.text!)
        }
    }
    
    func createViolation(plate:String, violation:String, location: String, description: String)
    {
        let cookie = HTTPCookieStorage.shared.cookies![0]
        ClientsAPI.ticketsCreatePost(body: TicketBase(image: (plateImageView.image?.jpegData(compressionQuality: 0.7))!,
                                                      licensePlate: licensePlateField.text,
                                                      violation: TicketBase.Violation.init(rawValue: violationPickerTextField.text!),
                                                      _description: descriptionField.text!,
                                                      location: TicketBase.Location.init(rawValue: pickerTextField.text!),
                                                      additionalComments: ""),
                                     accessToken: cookie.value){
            data, error in
            if(error == nil)
            {
                print("Success")
                self.licensePlateField.text = ""
                self.descriptionField.text = ""
                self.pickerTextField.text = self.locationPickerData[0]
                self.violationPickerTextField.text = self.violationPickerData[0]
            }
            else{
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == picker)
        {
            return locationPickerData.count
        }
        else if(pickerView == violationPicker)
        {
            return violationPickerData.count
        }
        
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == picker)
        {
            return locationPickerData[row]
        }
        else if(pickerView == violationPicker)
        {
            return violationPickerData[row]
        }
        
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == picker)
        {
            self.picker.isHidden = true
            self.pickerTextField.text = locationPickerData[row]
        }
        else if(pickerView == violationPicker)
        {
            self.violationPicker.isHidden = true
            self.violationPickerTextField.text = violationPickerData[row]
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == pickerTextField)
        {
            self.picker.isHidden = false
            self.violationPicker.isHidden = true
            return false
        }
        else if(textField == violationPickerTextField)
        {
            self.violationPicker.isHidden = false
            self.picker.isHidden = true
            return false
        }
        return false
    }
    
    //Action
    @objc func tapDetected() {
        ImagePickerManager().pickImage(self){ image in
            self.plateImageView.image = image
        }
    }
}
