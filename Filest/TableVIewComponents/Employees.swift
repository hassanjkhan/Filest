//
//  Employees.swift
//  Filest
//
//  Created by Hassan Khan on 2021-03-13.
//  Copyright © 2021 Z-Lux. All rights reserved.
//

import Foundation
import UIKit

class Employees {
    
    //MARK: Properties
    var name: String
    var job: String
    var photo: UIImage?
    var selected: Bool
    
    //MARK: Initialization
    
    init?(name: String, job: String, photo: UIImage, selected: Bool) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }

        // Initialize stored properties.
        self.name = name
        self.job = job
        self.photo = photo
        self.selected = selected
        
    }
    
    init?(name: String, job: String, selected: Bool) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }

        // Initialize stored properties.
        self.name = name
        self.job = job
        self.selected = selected
        
    }
    
    
}
