//
//  ContactUIView.swift
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

class ContactUIView: UIView {
    var fs: Firestore!
    var user: User!
    var businessCode: String!
    
    
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
    
    @objc fileprivate func animateIn(){
        self.container.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
        self.alpha = 0
        UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.titleLabel.transform = .identity
            self.alpha = 1
        })
        
    }
    
    @objc fileprivate func animateOut(){
        UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
            self.alpha = 0
        }) { (complete) in
            if complete {
                self.removeFromSuperview()
                
            }
        }
        

    }
    
    
        
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 31, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.text = "Name"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    
    required init(View: UIView, employee: Employees){
        super.init(frame: View.frame)
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

        user = Auth.auth().currentUser
        fs = Firestore.firestore()
        FetchEmployee(employee: employee)
        animateIn()

        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func FetchEmployee(employee: Employees){
        
    }
    /*
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
                                     if let cachedImage = delegate.contactsCache.object(forKey: ((userID)+".png") as NSString) {
                                         self.employees.append(Employees(name: (givenName + " " + familyname), job: jobTitle, photo: cachedImage, selected: selected, uid: userID)!)
                                         
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
                                                 self.employees.append(Employees(name: (givenName + " " + familyname), job: jobTitle, photo: (UIImage(data: imageData) ??        UIImage(named: "user"))!, selected: selected, uid: userID)!)
                                             } else {
                                                 self.employees.append(Employees(name: (givenName + " " + familyname), job: jobTitle, photo: UIImage(named: "user")!, selected: selected, uid: userID)!)
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
     */
    
    
    
}

