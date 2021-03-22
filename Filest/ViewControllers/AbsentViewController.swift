//
//  AbsentViewController.swift
//  Filest
//
//  Created by Hassan Khan on 2021-01-24.
//  Copyright © 2021 Z-Lux. All rights reserved.
//

import UIKit
import HorizonCalendar
import FirebaseAuth
import FirebaseDatabase
import Firebase

class AbsentViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var dateButtonOutlet: UIButton!
    @IBOutlet weak var addPeopleButtonOutlet: UIButton!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    @IBOutlet weak var descriptionBoxOutlet: UITextView!
    @IBOutlet weak var descriptionUILabel: UILabel!
    
    var user: User!
    var fs: Firestore!
    var companyID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dateButtonOutlet.layer.borderWidth = 1.0;
        dateButtonOutlet.layer.borderColor = (UIColor( red: 59/255, green: 64/255, blue:67/255, alpha: 1.0 )).cgColor
        addPeopleButtonOutlet.layer.borderWidth = 1.0;
        addPeopleButtonOutlet.layer.borderColor = (UIColor( red: 59/255, green: 64/255, blue:67/255, alpha: 1.0 )).cgColor
        submitButtonOutlet.layer.borderWidth = 1.0;
        submitButtonOutlet.layer.borderColor = (UIColor( red: 59/255, green: 64/255, blue:67/255, alpha: 1.0 )).cgColor
        
        descriptionBoxOutlet.isScrollEnabled = false
        descriptionBoxOutlet.delegate = self;
        
        user = Auth.auth().currentUser
        fs = Firestore.firestore()
        fs.collection("users").document(user!.uid).getDocument { (document, error) in
            if error != nil {
                print("joinbusiness Document Error => ", error!)
            } else {
                if let document = document {
                    if document.exists {
                        self.companyID =  (document.get("companyID") as! String)
                    }
                }
            }
        }
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(notification:)),
            name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(notification:)),
            name:UIResponder.keyboardWillHideNotification, object: nil)
        
    
        setDateTitle()
        
        let description = AbsentSingleton.getdescription()
        if description != "" {
            self.descriptionBoxOutlet.text = description
            self.descriptionUILabel.alpha = 0
        }
        
    }
   
    
    
    @IBAction func addEmployeesButton(_ sender: Any) {
        let addEmployee = addEmployeesUIView(VC: self)
        self.view.addSubview(addEmployee)
       
    }
    
    @IBAction func dateButton(_ sender: UIButton) {
        let pop = CalendarPopUpView(VC: self)
        self.view.addSubview(pop)
        
    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        if(textView.text == ""){
            self.descriptionUILabel.alpha = 1
        } else {
            self.descriptionUILabel.alpha = 0
        }
        AbsentSingleton.setdescription(description: textView.text)
        
    }
    
    @IBAction func submitButton(_ sender: Any) {
        let db = Firestore.firestore()
        let AR = AbsentSingleton.sharedInstance
        db.collection("companies").document(companyID ?? "" ).collection("absent").addDocument(data:
                                                                                                ["description" : AR.description,
                                                                                     "from" : self.user!.uid,
                                                                                     "to" : AR.to,
                                                                                     "dateFrom" : AR.fromDate,
                                                                                     "dateTo" : AR.toDate])
        AbsentSingleton.refresh()
        
        self.dismiss(animated: true) 
            
    }
    
    
    @objc func keyboardWillShow(notification:NSNotification){
        self.addPeopleButtonOutlet.isEnabled = false
        self.submitButtonOutlet.isEnabled = false
        self.dateButtonOutlet.isEnabled = false
        self.isModalInPresentation = true
        
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        self.addPeopleButtonOutlet.isEnabled = true
        self.submitButtonOutlet.isEnabled = true
        self.dateButtonOutlet.isEnabled = true
        self.isModalInPresentation = false
        
        
    }
    
    func dateParse(Date: Date) -> String{
        let weekday = getWeekDay(weekDay: Date.get(.weekday)) + ", "
        let month = getMonth(month: Date.get(.month)) + " "
        let day = Date.get(.day).description
        
        return weekday + month + day
    }
    
    func getWeekDay(weekDay: Int) -> String{
        
        switch weekDay {

        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return ""
        }
    }
    
    func getMonth(month: Int) -> String{
        switch month {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "Aug"
        case 9:
            return "Sept"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return ""
        }
    }
    
    func setDateTitle(){
        let fromDate = AbsentSingleton.getfromDate()
        let toDate = AbsentSingleton.gettoDate()
        let yesterday = Date.yesterday
        if (fromDate > yesterday){
            if (fromDate >= toDate){
                self.dateButtonOutlet.setTitle(dateParse(Date:fromDate), for: .normal)
            } else {
                self.dateButtonOutlet.setTitle(dateParse(Date:fromDate) + " to " + dateParse(Date: toDate), for: .normal)
            }
            
        }
    }
}


