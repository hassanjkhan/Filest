//
//  ProfileViewController.swift
//  Filest
//
//  Created by admin on 2020-07-09.
//  Copyright © 2020 Z-Lux. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase


class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var beginLabel: UILabel!
    @IBOutlet weak var beginButton: UIButton!

    var inBusiness: Bool!
    var fs: Firestore!
    var user: User!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { get { return .portrait } }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up firebase references
        user = Auth.auth().currentUser
        fs = Firestore.firestore()
        inBusiness = false
        
        // Do any additional setup after loading the view.
        errorLabel.alpha = 0
        jobTitle.alpha = 0
        
        // Rounding phone button
        phoneButton.layer.cornerRadius = 17
        phoneButton.clipsToBounds = true
        
        // Rounding email button
        emailButton.layer.cornerRadius = 17
        emailButton.clipsToBounds = true
        
        // Rounding sign up button
        signOutButton.layer.cornerRadius = 23
        signOutButton.clipsToBounds = true
        
        // Rounding Begin businss button
        beginButton.layer.cornerRadius = 23
        beginButton.clipsToBounds = true
        
        setUserInformation();
        
        // Starts with begin label and button as disabled
        self.beginButton.alpha = 0
        self.beginButton.isEnabled = false
        self.beginLabel.alpha = 0
        
        
        // check if user is in a business
        let docref =  fs.collection("users").document(user!.uid)
        //users/oYpWjZIkXcQBghpjMEmtDDOUetB3
        docref.getDocument { (document, error) in
            
            if error != nil {
                print("Document Error => ", error!)
            } else {
                if let document = document {
                    if document.exists {
                        self.inBusiness = true
                        self.beginLabel.alpha = 1
                        self.beginLabel.text = "Your business code is : 1234"
                    } else {
                        self.inBusiness = false
                        self.beginButton.alpha = 1
                        self.beginButton.isEnabled = true
                        self.beginLabel.alpha = 1
                    }
                }
            }
            
        }
        
    }
    
    
    @IBAction func Logout(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
          try
        
            firebaseAuth.signOut()
            self.TransitiontoLogin()
            
        } catch let signOutError as NSError {
            errorLabel.text = signOutError.localizedFailureReason
            errorLabel.alpha = 1
          print ("Error signing out: %@", signOutError)
        }
    
    }

    func TransitiontoLogin(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
        LoginViewController.modalPresentationStyle = .fullScreen
        LoginViewController.modalTransitionStyle = .crossDissolve
        present(LoginViewController, animated: true)
    }
    
    
    @IBAction func TransitiontoEdit(){
        // if user is not in a company then call assignCompany()
        if (!self.inBusiness){
            self.assignCompany()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let EditViewController = storyboard.instantiateViewController(identifier: "EditViewController")
            EditViewController.modalPresentationStyle = .fullScreen
            EditViewController.modalTransitionStyle = .crossDissolve
            present(EditViewController, animated: true)
        }
        
    }
    
    
    /*
     Reads user data and sets the variables accordingly.
     Reads name, email, phone number, profile photo
     */
    func setUserInformation(){
        self.name.text = user?.displayName
        self.emailButton.setTitle("    " + (user?.email)!, for: .normal)
        if user?.phoneNumber != nil {
            self.phoneButton.setTitle(user?.phoneNumber, for: .normal)
        }
        
        let storageRef = Storage.storage().reference().child((user?.uid ?? "")+".png")
        storageRef.downloadURL { (url, error) in
            if error != nil {
                
            } else {
                let imageUrlString = url?.absoluteString

                let imageUrl = URL(string: imageUrlString!)!

                let imageData = try! Data(contentsOf: imageUrl)

                self.profileImage.image = UIImage(data: imageData)
                
                self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
                self.profileImage.clipsToBounds = true
            }
            
        }
        
    }
    
    /*
        Run assignCompany
    */
    @IBAction func Begin(){
        self.assignCompany()
    }
        
    /*
     Checks firebase to see if user is assigned to a company, if not alert to make one or join one.
     */
    func assignCompany(){
        
        let alert = UIAlertController(title: "Connect with your company", message: "Start or join a business!", preferredStyle: .alert)
        let user = Auth.auth().currentUser
        let database = Firestore.firestore()
        
        alert.addAction(UIAlertAction(title: "Join a businss", style: .default, handler:   { action in
            //add another alert that asks for code, checks if code exists, if it does then adds user to business
            database.collection("users").document(user!.uid).setData(["companyID":"1234"])
        }))
        
        alert.addAction(UIAlertAction(title: "Start a businss", style: .default, handler: { action in
            
            //Create random code, show code on profile!
            database.collection("users").document(user!.uid).setData(["companyID":"1234"])
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler:  { action in}))
        
        self.present(alert, animated: true)
        
    }

}

