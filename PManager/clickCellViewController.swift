//
//  clickCellViewController.swift
//  PManager
//
//  Created by Lauryn Landkrohn on 4/19/20.
//  Copyright © 2020 Lauryn Landkrohn. All rights reserved.
//

import UIKit

class clickCelliewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    

   @IBOutlet weak var violationPicker: UIPickerView!
   @IBOutlet weak var picker: UIPickerView!
   @IBOutlet weak var pickerTextField: UITextField!
   @IBOutlet weak var violationPickerTextField: UITextField!
   @IBOutlet weak var plateImageView: UIImageView!
   @IBOutlet weak var licensePlateField: UITextField!
   @IBOutlet weak var descriptionField: UITextField!
    
    var ticket: DatabaseTicket? = nil
   
   var locationPickerData: [String] = []
   var violationPickerData: [String] = []
    
   @IBAction func unwind(_ segue: UIStoryboardSegue) {}
   
   override func viewDidLoad() {
       super.viewDidLoad()
       picker.isHidden = true;
       
       picker.isHidden = true
       violationPicker.isHidden = true
    
    
       licensePlateField.text = ticket!.licensePlate
    violationPickerTextField.text = ticket!.violation?.rawValue
    pickerTextField.text = ticket!.location?.rawValue
    descriptionField.text = ticket!._description
    plateImageView.image = UIImage(data: ticket!.image!.data!)
    
    plateImageView.clipsToBounds = true
    plateImageView.contentMode = .scaleAspectFit
       
       ClientsAPI.enumsGet() { data, error in
           self.locationPickerData = data?.locations as! [String]
           self.violationPickerData = data?.violations as! [String]
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
   
   @IBAction func DoUpdateViolation(_ sender: Any) {
       if(!(descriptionField.text!).isEmpty &&
       !(pickerTextField.text!).isEmpty &&
       !(violationPickerTextField.text!).isEmpty &&
       !(licensePlateField.text!).isEmpty)
       {
           updateViolation(plate: licensePlateField.text!, violation: violationPickerTextField.text!, location: pickerTextField.text!, description: descriptionField.text!)
       }
   }
   
   func updateViolation(plate:String, violation:String, location: String, description: String)
   {
       let cookie = HTTPCookieStorage.shared.cookies![0]
    ClientsAPI.ticketsTicketIdPost(accessToken: cookie.value, ticketId:ticket!._id, body: UpdateTicketRequest(image: (plateImageView.image?.jpegData(compressionQuality: 0.7))!, licensePlate: plate, violation: UpdateTicketRequest.Violation.init(rawValue: violation), _description: description, location: UpdateTicketRequest.Location.init(rawValue: location), additionalComments: ticket?.additionalComments, status: UpdateTicketRequest.Status.init(rawValue: (ticket?.status.rawValue)!))) { data, error in
        if(error == nil)
        {
            print("success")
//            self.performSegue(withIdentifier: "unwindToList", sender: self)
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
