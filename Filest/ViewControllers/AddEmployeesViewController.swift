//
//  AddEmployeesViewController.swift
//  Filest
//
//  Created by Hassan Khan on 2021-03-13.
//  Copyright © 2021 Z-Lux. All rights reserved.
//

import UIKit

class AddEmployeesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let addEmployee = addEmployeesUIView()
        self.view.addSubview(addEmployee)
    }
    
}
