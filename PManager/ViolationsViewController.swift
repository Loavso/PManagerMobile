//
//  ViolationsViewController.swift
//  PManager
//
//  Created by Lauryn Landkrohn on 4/18/20.
//  Copyright © 2020 Lauryn Landkrohn. All rights reserved.
//

import UIKit

class ViolationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var listTableView: UITableView!
    
    var violations = [DatabaseTicket]()
    var tempIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        getViolations()
    }
    
    func getViolations() {
//        violations.append(Violation(plate: "test plate", date: "01/01/2020", violationDesc: "Parking Violation"))
        let cookie = HTTPCookieStorage.shared.cookies![0]
        var userID: String?
        ClientsAPI.authUserInfoGet(accessToken: cookie.value) { data, error in
            if(error == nil)
            {
                userID = data?.userId
//                print(userID)
            }
        }
//        ClientsAPI.ticketsTicketIdGet(accessToken: cookie.value, ticketId: "5e9e050a9a716e001162743c"){data, error in
//            self.violations.append(data!)
//            self.listTableView.reloadData()
//        }
        ClientsAPI.ticketsQueryGet(){data, error in
            if(error == nil)
            {
                self.violations = data!.docs!
//                print(data?.docs!)
                self.listTableView.reloadData()
            }
            else
            {
                print("error: \(String(describing: error))")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return violations.count
    }
    
    func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {

       // Reuse or create a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "violationCell",
                             for: indexPath) as! ViolationCell

       // Fetch the data for the row.
       let violation = violations[indexPath.row]
            
       // Configure the cell’s contents with data from the fetched object.
        var dateString = DateFormatter.localizedString(from: stringToDate(date: violation.createdAt), dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.short)
        
        cell.plate?.text = violation.licensePlate
        cell.date?.text = dateString
        cell.violationDesc?.text = violation.violation?.rawValue
        cell.plateImage?.image = UIImage(data: violation.image!.data!)
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tempIndex = indexPath.row
        performSegue(withIdentifier: "cellViewSegue", sender: self)
    }
    
    func stringToDate(date: String) -> Date {
        let formatter = DateFormatter()

        // Format 1
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let parsedDate = formatter.date(from: date) {
            return parsedDate
        }

        // Format 2
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:SSSZ"
        if let parsedDate = formatter.date(from: date) {
            return parsedDate
        }

        // Couldn't parsed with any format. Just get the date
        let splitedDate = date.components(separatedBy: "T")
        if splitedDate.count > 0 {
            formatter.dateFormat = "yyyy-MM-dd"
            if let parsedDate = formatter.date(from: splitedDate[0]) {
                return parsedDate
            }
        }

        // Nothing worked!
        return Date()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is clickCelliewController
        {
            let vc = segue.destination as? clickCelliewController
            vc?.ticket = violations[tempIndex]
        }
    }
    
    @IBAction func refreshTable(_ sender: Any) {
        getViolations()
    }
}


