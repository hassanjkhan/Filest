//
//  EmployeesTableViewCell.swift
//  Filest
//
//  Created by Hassan Khan on 2021-03-13.
//  Copyright © 2021 Z-Lux. All rights reserved.
//

import UIKit

class EmployeeCell: UITableViewCell {

    
    @IBOutlet var nameUILabel: UILabel!
    @IBOutlet var jobUILabel: UILabel!
    @IBOutlet var selectUISwitch: UISwitch!
    
    @IBOutlet var EmployeeUIImage: UIImageView!{
        didSet {
            EmployeeUIImage.layer.masksToBounds = true
            EmployeeUIImage.layer.cornerRadius = EmployeeUIImage.frame.width/2
            EmployeeUIImage.clipsToBounds = true
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if self.traitCollection.userInterfaceStyle == .light {
            self.backgroundColor  = .white
            jobUILabel.textColor  = .gray
            nameUILabel.textColor = .black
        } else {
            self.backgroundColor  = .black
            jobUILabel.textColor  = .white
            nameUILabel.textColor = .white
        }

        selectUISwitch.centerXAnchor.constraint(equalTo: self.rightAnchor, constant: -40).isActive = true
        // Initialization code
    }
    
    func updateModeView(){
        if self.traitCollection.userInterfaceStyle == .light {
            self.backgroundColor  = .white
            jobUILabel.textColor  = .gray
            nameUILabel.textColor = .black
        } else {
            self.backgroundColor  = .gray
            jobUILabel.textColor  = .white
            nameUILabel.textColor = .white
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
