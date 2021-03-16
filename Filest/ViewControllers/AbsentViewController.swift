//
//  AbsentViewController.swift
//  Filest
//
//  Created by Hassan Khan on 2021-01-24.
//  Copyright © 2021 Z-Lux. All rights reserved.
//

import UIKit
import HorizonCalendar

class AbsentViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var dateButtonOutlet: UIButton!
    @IBOutlet weak var addPeopleButtonOutlet: UIButton!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    @IBOutlet weak var descriptionBoxOutlet: UITextView!
    @IBOutlet weak var descriptionUILabel: UILabel!
    
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
    
    }

    
    @IBAction func addEmployeesButton(_ sender: Any) {
//        let addEmployee = addEmployeesUIView()
//        self.view.addSubview(addEmployee)
    }
    
    @IBAction func dateButton(_ sender: UIButton) {
        let pop = CalendarPopUpView()
        self.view.addSubview(pop)
    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        if(textView.text == ""){
            self.descriptionUILabel.alpha = 1
        } else {
            self.descriptionUILabel.alpha = 0
        }
    }
    
}
