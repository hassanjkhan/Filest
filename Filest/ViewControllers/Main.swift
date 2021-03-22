//
//  Main.swift
//  Filest
//
//  Created by admin on 2020-06-29.
//  Copyright © 2020 Z-Lux. All rights reserved.
//

import UIKit

class Main: UIViewController {
    

    @IBOutlet weak var Absent: UIButton!
    @IBOutlet weak var Vacation: UIButton!
    @IBOutlet weak var Meeting: UIButton!
    
    @IBOutlet weak var AbsentTitle: UILabel!
    @IBOutlet weak var AbsentDescription: UILabel!
    @IBOutlet weak var MeetingTitle: UILabel!
    @IBOutlet weak var MeetingDescription: UILabel!
    @IBOutlet weak var VacationTitle: UILabel!
    @IBOutlet weak var VacationDescription: UILabel!
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{ get { return .portrait } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        Meeting.isEnabled = false
        Meeting.alpha = 0
        MeetingTitle.alpha = 0
        MeetingDescription.alpha = 0
        
        Vacation.isEnabled = false
        Vacation.alpha = 0
        VacationTitle.alpha = 0
        VacationDescription.alpha = 0
        

        let height = UIScreen.main.bounds.size.height * 0.27
        
        Absent.layer.cornerRadius = 20
        Absent.clipsToBounds = true
        Absent.layer.borderWidth = 4
        Absent.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        
        Meeting.layer.cornerRadius = 20
        Meeting.clipsToBounds = true
        Meeting.layer.borderWidth = 4
        Meeting.heightAnchor.constraint(equalToConstant: height).isActive = true
        

        Vacation.layer.cornerRadius = 20
        Vacation.clipsToBounds = true
        Vacation.layer.borderWidth = 4
        Vacation.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        
    }
    
}
