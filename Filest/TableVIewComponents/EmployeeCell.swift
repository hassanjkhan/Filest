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
    @IBAction func switchSelected(_ sender: UISwitch) {
        guard let tv = self.superview as? UITableView, let ip = tv.indexPath(for: self) else {
            fatalError("Unable to cast self.superview as UITableView or get indexPath")
        }
        setSelected(sender.isOn, animated: true)
        if sender.isOn {
            tv.delegate?.tableView?(tv, didSelectRowAt: ip)
        } else {
            tv.delegate?.tableView?(tv, didDeselectRowAt: ip)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        jobUILabel.textColor = UIColor.label
        nameUILabel.textColor = UIColor.label
        self.backgroundColor = .systemBackground
        selectUISwitch.centerXAnchor.constraint(equalTo: self.rightAnchor, constant: -40).isActive = true
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

    }

}
