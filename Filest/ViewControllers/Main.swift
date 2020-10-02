//
//  Main.swift
//  Filest
//
//  Created by admin on 2020-06-29.
//  Copyright © 2020 Z-Lux. All rights reserved.
//

import UIKit

class Main: UIViewController {
    
//    @IBOutlet weak var Meeting: UIButton!
//    @IBOutlet weak var Expenses: UIButton!
//    @IBOutlet weak var Feedback: UIButton!
//    @IBOutlet weak var Vacation: UIButton!
//    @IBOutlet weak var Training: UIButton!
//    @IBOutlet weak var Absent: UIButton!
    @IBOutlet weak var Absent: UIButton!
    @IBOutlet weak var Expense: UIButton!
    @IBOutlet weak var Vacation: UIButton!
    @IBOutlet weak var Meeting: UIButton!
    @IBOutlet weak var Training: UIButton!
    @IBOutlet weak var Feedback: UIButton!
  
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{ get { return .portrait } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Training.layer.cornerRadius = 20
        Training.clipsToBounds = true
        Training.layer.borderWidth = 4
        
        Vacation.layer.cornerRadius = 20
        Vacation.clipsToBounds = true
        Vacation.layer.borderWidth = 4
        
        Feedback.layer.cornerRadius = 20
        Feedback.clipsToBounds = true
        Feedback.layer.borderWidth = 4
        
        Expense.layer.cornerRadius = 20
        Expense.clipsToBounds = true
        Expense.layer.borderWidth = 4
        
        Meeting.layer.cornerRadius = 20
        Meeting.clipsToBounds = true
        Meeting.layer.borderWidth = 4
        
        Absent.layer.cornerRadius = 20
        Absent.clipsToBounds = true
        Absent.layer.borderWidth = 4
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
