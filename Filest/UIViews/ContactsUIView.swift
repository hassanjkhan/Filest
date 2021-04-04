//
//  ContactsUIView.swift
//  Filest
//
//  Created by Hassan Khan on 2021-03-22.
//  Copyright © 2021 Z-Lux. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

class ContactsUIView : UIView {
    var fs: Firestore!
    var user: User!
    var businessCode: String!
    
    let tableView = UITableView()
    var employees : [Employees] = [Employees]()
    
    fileprivate let container: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .systemGray6
        v.layer.cornerRadius = 24
        return v
    }()
    
    fileprivate let topContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.init(red: 125/255, green:  113/255, blue:  211/255, alpha: 1.0)
        return v
    }()
    

    
//    fileprivate let searchBar: UITextField = {
//        let t = UITextField()
//        t.translatesAutoresizingMaskIntoConstraints = false
//        t.backgroundColor = UIColor.init(red: 197/255, green:  189/255, blue:  252/255, alpha: 1.0)
//        return t
//    }()
    
        
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 31, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.text = "Contacts"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
        self.backgroundColor = .systemBackground
        
        
                
        self.addSubview(container)
        
        container.addSubview(topContainer)
        container.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        topContainer.topAnchor.constraint(equalTo:container.topAnchor).isActive = true
        topContainer.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        topContainer.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        topContainer.heightAnchor.constraint(equalToConstant: 90.0).isActive = true
        
        topContainer.addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: -30).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor).isActive = true
        titleLabel.rightAnchor.constraint(lessThanOrEqualTo: topContainer.rightAnchor, constant: -25).isActive = true
        titleLabel.leftAnchor.constraint(lessThanOrEqualTo: topContainer.leftAnchor, constant: 25).isActive = true
        
        container.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topContainer.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EmployeeCell", bundle: nil), forCellReuseIdentifier: "EmployeeCell")

        user = Auth.auth().currentUser
        fs = Firestore.firestore()
        
        DispatchQueue.main.async {
            self.SelectFetchEmployees(textField: UITextField.init())
        }
        
        

        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func SelectFetchEmployees(textField: UITextField){
        let docref =  fs.collection("users").document(user!.uid)
        
        docref.getDocument{ (document, error) in
            if error != nil {
                print("Friend Document Error => ", error!)
            } else {
                if let document = document {
                    if document.exists {
                        self.businessCode = (document.get("companyID") as! String)
                        self.fs.collection("companies").document(self.businessCode).collection("employees").getDocuments { (querySnapshot, err) in
                            
                            if let err = err {
                                print("Error getting documents getEmployeesData: \(err)")
                            } else {
                                let delegate = UIApplication.shared.delegate as! AppDelegate
                                
                                for document in querySnapshot!.documents {
                                    let userID = document.documentID
                                    let selected = false
                                    let givenName   = document.get("givenName") as! String
                                    let familyname  = document.get("familyName") as! String
                                    let jobTitle    = document.get("jobTitle") as! String
                                    let storageRef  = Storage.storage().reference().child((userID)+".png")
                                    let email       = document.get("email") as! String
                                    let phoneNumber = document.get("phoneNumber") as! String
                                    if let cachedImage = delegate.contactsCache.object(forKey: ((userID)+".png") as NSString) {
                                        self.employees.append(Employees(name: (givenName + " " + familyname), job: jobTitle, photo: cachedImage, selected: selected, uid: userID, email: email, phoneNumber: phoneNumber)!)
                                        
                                        self.employees.sort { (Employee1: Employees, Employee2: Employees) -> Bool in
                                            return Employee1.name < Employee2.name
                                        }
                                        self.tableView.reloadData()
                                    } else {
                                        storageRef.downloadURL { (url, error) in
                                            if error == nil {
                                                let imageUrlString = url?.absoluteString
                                                let imageUrl = URL(string: imageUrlString!)
                                                let imageData = try! Data(contentsOf: imageUrl!)
                                                
                                                if imageUrl != nil {
                                                    delegate.contactsCache.setObject(UIImage(data: imageData)!, forKey: ((userID)+".png") as NSString)
                                                }
                                                self.employees.append(Employees(name: (givenName + " " + familyname), job: jobTitle, photo: (UIImage(data: imageData) ??        UIImage(named: "user"))!, selected: selected, uid: userID, email: email, phoneNumber: phoneNumber)!)
                                            } else {
                                                self.employees.append(Employees(name: (givenName + " " + familyname), job: jobTitle, photo: UIImage(named: "user")!, selected: selected, uid: userID, email: email, phoneNumber: phoneNumber)!)
                                            }
                                            self.employees.sort { (Employee1: Employees, Employee2: Employees) -> Bool in
                                                return Employee1.name < Employee2.name
                                            }
                                            self.tableView.reloadData()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
}

extension ContactsUIView: UITableViewDataSource, UITableViewDelegate{
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell",for:indexPath) as! EmployeeCell

        let currentEmployee = employees[indexPath.row]
        cell.EmployeeUIImage.image = currentEmployee.photo
        cell.nameUILabel.text = currentEmployee.name
        cell.jobUILabel.text = currentEmployee.job
        cell.selectUISwitch.alpha = 0
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactUIView = ContactUIView(View: self,employee: employees[indexPath.row])
        self.addSubview(contactUIView)
        contactUIView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contactUIView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contactUIView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        contactUIView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
    }

    
}


