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

        let height = UIScreen.main.bounds.size.height * 0.27
//        let width = UIScreen.main.bounds.size.height
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
        
        
        
//        AbsentTitle.frame = CGRect(x: 30, y: Absent.frame.origin.y + (height * 0.03), width: 176, height: 32)
//        AbsentDescription.frame = CGRect(x:30, y: AbsentTitle.frame.origin.y + height - 55, width: 183, height: 16)
//        
//        MeetingTitle.frame = CGRect(x: 30, y: AbsentDescription.frame.origin.y + 64, width: 239, height: 32)
//        MeetingDescription.frame = CGRect(x:30, y: MeetingTitle.frame.origin.y + height - 55 , width: 240, height: 16)
//        
//        VacationTitle.frame = CGRect(x: 30, y: MeetingDescription.frame.origin.y + 64, width: 116, height: 32)
//        VacationDescription.frame = CGRect(x:30, y: VacationTitle.frame.origin.y + height - 55, width: 200, height: 16)
//        
        
        

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
