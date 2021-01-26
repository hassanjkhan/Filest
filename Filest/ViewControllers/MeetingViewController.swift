//
//  MeetingViewController.swift
//  Filest
//
//  Created by Hassan Khan on 2021-01-06.
//  Copyright © 2021 Z-Lux. All rights reserved.
//

import FSCalendar
import UIKit

class MeetingViewController: UIViewController, FSCalendarDelegate {

    @IBOutlet var calendar: FSCalendar!    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("selected")
      
    }
    @IBAction func dateButton(_ sender: UIButton) {
        calendar.frame = CGRect(x: 0, y: 50, width: 300, height: 0)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
