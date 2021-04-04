//
//  addEmployeesUIView.swift
//  Filest
//
//  Created by Hassan Khan on 2021-03-13.
//  Copyright © 2021 Z-Lux. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

class addEmployeesUIView: UIView {
    var fs: Firestore!
    var user: User!
    var businessCode: String!
    var parentVC: AbsentViewController!
    
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
    
    fileprivate let bottomContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.init(red: 125/255, green:  113/255, blue:  211/255, alpha: 1.0)
        return v
    }()
    
    fileprivate let selectButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .white
        b.setTitleColor(UIColor.init(red: 125/255, green:  113/255, blue:  211/255, alpha: 1.0), for: .normal)
        b.setTitle("Select", for: .normal)
        b.addTarget(self, action: #selector(animateOut), for: .touchUpInside)
        b.layer.cornerRadius = 23
        return b
    }()
    
    fileprivate let searchBar: UITextField = {
        let t = UITextField()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.backgroundColor = UIColor.init(red: 197/255, green:  189/255, blue:  252/255, alpha: 1.0)
        return t
    }()
    
        
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 31, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.text = "Who would you like to notify?"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    @objc fileprivate func animateIn(){
        SelectFetchEmployees(textField: UITextField.init())
        self.container.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
        self.alpha = 0
        UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.titleLabel.transform = .identity
            self.alpha = 1
        })
        self.parentVC.isModalInPresentation = true
        
    }
    
    @objc fileprivate func animateOut(){
        UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
            self.alpha = 0
        }) { (complete) in
            if complete {
                self.removeFromSuperview()
                self.parentVC.isModalInPresentation = false
                self.parentVC.updatetoEmployees()
            }
        }
        

    }
    
    required init(VC: AbsentViewController, frame: CGRect){
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = UIColor.init(red: 125/255, green: 113/255, blue:  211/255, alpha: 0.6)
        self.parentVC = VC
                
        self.addSubview(container)
        
        container.addSubview(topContainer)
        container.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.975 ).isActive = true
        
        
        topContainer.topAnchor.constraint(equalTo:container.topAnchor).isActive = true
        topContainer.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        topContainer.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        topContainer.heightAnchor.constraint(equalToConstant: 65.0).isActive = true
        
        topContainer.addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor).isActive = true
        titleLabel.rightAnchor.constraint(lessThanOrEqualTo: topContainer.rightAnchor, constant: -25).isActive = true
        titleLabel.leftAnchor.constraint(lessThanOrEqualTo: topContainer.leftAnchor, constant: 25).isActive = true
        
        container.addSubview(tableView)
        container.addSubview(bottomContainer)
        bottomContainer.addSubview(selectButton)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topContainer.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor).isActive = true
        
        
        bottomContainer.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        bottomContainer.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        bottomContainer.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        bottomContainer.bottomAnchor.constraint(equalTo:container.bottomAnchor).isActive = true
        
        selectButton.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor).isActive = true
        selectButton.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 20).isActive = true
        selectButton.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.40).isActive = true
        selectButton.heightAnchor.constraint(equalTo: bottomContainer.heightAnchor, multiplier: 0.30).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EmployeeCell", bundle: nil), forCellReuseIdentifier: "EmployeeCell")

        user = Auth.auth().currentUser
        fs = Firestore.firestore()
        
        
        
        animateIn()

        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func SelectFetchEmployees(textField: UITextField){
        let docref =  fs.collection("users").document(user!.uid)
        DispatchQueue.global(qos: .utility).async {
        
        
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
                                        let selected = AbsentSingleton.getto().contains(userID)
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
    
}

extension addEmployeesUIView: UITableViewDataSource, UITableViewDelegate{
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell",for:indexPath) as! EmployeeCell

        let currentEmployee = employees[indexPath.row]
        cell.EmployeeUIImage.image = currentEmployee.photo
        cell.nameUILabel.text = currentEmployee.name
        cell.jobUILabel.text = currentEmployee.job
        
        cell.selectUISwitch.setOn(currentEmployee.selected, animated: false)

        if cell.isSelected { // stored value to know if the switch is on or off
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false // to disable interaction since it happens on the switch
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // do your thing when selecting
        
        let currentEmployee = employees[indexPath.row]
        currentEmployee.selected = true
        AbsentSingleton.addto(uid: currentEmployee.uid)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // do your thing when deselecting
        
        let currentEmployee = employees[indexPath.row]
        currentEmployee.selected = false
        AbsentSingleton.removeto(uid:  currentEmployee.uid)
    }

}
