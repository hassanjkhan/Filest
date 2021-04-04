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
        v.backgroundColor = .systemBackground
        v.layer.cornerRadius = 24
        return v
    }()
    

    fileprivate let topContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.init(red: 125/255, green:  113/255, blue:  211/255, alpha: 1.0)
        return v
    }()
    
    fileprivate let profilePhoto: UIImageView = {
        let p = UIImageView(image: UIImage(named: "user"))
        p.translatesAutoresizingMaskIntoConstraints = false
        p.layer.masksToBounds = false
        p.layer.cornerRadius = 42
        p.clipsToBounds = true
        p.contentMode = .scaleAspectFill
        return p

    }()
    
    fileprivate let backButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Back", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor.init(red: 125/255, green:  113/255, blue:  211/255, alpha: 1.0)
        b.layer.cornerRadius = 15
        b.clipsToBounds = true
        b.addTarget(self, action: #selector(animateOut), for: .touchUpInside)
        return b

    }()
    
    fileprivate let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.text = "Name"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    
    fileprivate let jobLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.text = "Job"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let phoneLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 9, weight: .regular)
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = 0.2
        l.text = "phone number"
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()

    
    fileprivate let phoneButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("(000)-000-0000", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor.init(red: 125/255, green:  113/255, blue:  211/255, alpha: 1.0)
        b.layer.cornerRadius = 17
        b.clipsToBounds = true
        return b
    }()
    
    fileprivate let emailLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 9, weight: .regular)
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = 0.2
        l.text = "email"
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()

    
    fileprivate let emailButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("user@email.com", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor.init(red: 125/255, green:  113/255, blue:  211/255, alpha: 1.0)
        b.layer.cornerRadius = 17
        b.clipsToBounds = true
        return b
    }()
    
    @objc fileprivate func animateIn(){
        self.container.transform = CGAffineTransform(translationX: self.frame.width, y: 0)
        self.alpha = 0
        UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.alpha = 1
        })
        
    }
    
    @objc fileprivate func animateOut(){
        UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = CGAffineTransform(translationX: self.frame.width, y: 0)
            self.alpha = 0
        }) { (complete) in
            if complete {
                self.removeFromSuperview()
            }
        }

    }

    
    required init(View: UIView, employee: Employees){
        super.init(frame: View.frame)
        self.frame = UIScreen.main.bounds
        self.backgroundColor = .systemBackground
        
        self.addSubview(container)
        
        container.addSubview(topContainer)
        container.topAnchor.constraint(equalTo:      self.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo:   self.bottomAnchor).isActive = true
        container.leftAnchor.constraint(equalTo:     self.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo:    self.rightAnchor).isActive = true
        
        topContainer.topAnchor.constraint(equalTo:   self.topAnchor).isActive = true
        topContainer.leftAnchor.constraint(equalTo:  self.leftAnchor).isActive = true
        topContainer.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        topContainer.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
         
        topContainer.addSubview(profilePhoto)
        profilePhoto.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        profilePhoto.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profilePhoto.widthAnchor.constraint(equalToConstant: 84).isActive = true
        profilePhoto.heightAnchor.constraint(equalToConstant: 84).isActive = true
        
            
        topContainer.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 12).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: topContainer.rightAnchor, constant: -25).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: topContainer.leftAnchor, constant: 25).isActive = true
        
        topContainer.addSubview(jobLabel)
        jobLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12).isActive = true
        jobLabel.rightAnchor.constraint(equalTo: topContainer.rightAnchor, constant: -25).isActive = true
        jobLabel.leftAnchor.constraint(equalTo: topContainer.leftAnchor, constant: 25).isActive = true
        
        topContainer.bottomAnchor.constraint(equalTo: jobLabel.bottomAnchor, constant: 13).isActive = true

        
        container.addSubview(phoneButton)
        phoneButton.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 45).isActive = true
        phoneButton.leftAnchor.constraint(equalTo: container.leftAnchor, constant:  15).isActive = true
        phoneButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant:  -15).isActive = true
        phoneButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        container.addSubview(phoneLabel)
        phoneLabel.leadingAnchor.constraint(equalTo: phoneButton.leadingAnchor, constant:  17).isActive = true
        phoneLabel.topAnchor.constraint(equalTo: phoneButton.topAnchor, constant: 9).isActive = true
        phoneLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
        phoneLabel.widthAnchor.constraint(equalToConstant: 64).isActive = true
        
        container.addSubview(emailButton)
        emailButton.topAnchor.constraint(equalTo: phoneButton.bottomAnchor, constant: 5).isActive = true
        emailButton.leftAnchor.constraint(equalTo: container.leftAnchor, constant:  15).isActive = true
        emailButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant:  -15).isActive = true
        emailButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        container.addSubview(emailLabel)
        emailLabel.leadingAnchor.constraint(equalTo: emailButton.leadingAnchor, constant:  17).isActive = true
        emailLabel.topAnchor.constraint(equalTo: emailButton.topAnchor, constant: 9).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
        emailLabel.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        user = Auth.auth().currentUser
        fs = Firestore.firestore()
        FetchEmployee(employee: employee)
        animateIn()

        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func FetchEmployee(employee: Employees){
        self.jobLabel.text = employee.job
        self.nameLabel.text = employee.name
        self.profilePhoto.image = employee.photo
        self.emailButton.setTitle(employee.email, for: .normal)
        self.phoneButton.setTitle(employee.phoneNumber, for: .normal)        
    }
    
    
    
}

