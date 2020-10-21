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
    var businessCode: String!
    
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
        
        // check if user is in a business
        let docref =  fs.collection("users").document(user!.uid)
        docref.getDocument { (document, error) in
            
            if error != nil {
                print("Document Error => ", error!)
            } else {
                if let document = document {
                    if document.exists {
                        self.inBusiness = true
                        self.beginLabel.alpha = 1
                        self.businessCode = (document.get("companyID") as! String)
                        self.beginLabel.text = "Your business code is : " + self.businessCode
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
        let joinAlert = UIAlertController(title: "Enter the company code", message: "This should be a code with 7 digits or numbers", preferredStyle: .alert)
        let database = Firestore.firestore()
        
        alert.addAction(UIAlertAction(title: "Start a business", style: .default, handler:   { action in

            // adding user to users with their companyID create a new collection in companies collection containing all the basics for actions
            self.startBussiness(db: database)

        }))
        
        alert.addAction(UIAlertAction(title: "Join a business", style: .default, handler: { action in
            
            joinAlert.addTextField { (textField) in
                textField.placeholder = "ADCD123"
            }
            
            joinAlert.addAction(UIAlertAction(title: "Join", style: .default, handler:   { action in
                
                //add another alert that asks for code, checks if code exists, if it does then adds user to business
                let code = joinAlert.textFields![0].text
                
                self.joinBusiness(code: code ?? "")
                
            }))
            
            self.present(joinAlert, animated: true)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler:  { action in}))
        
        self.present(alert, animated: true)
        
    }
    
    func joinBusiness(code: String){
        
    }
    func startBussiness(db: Firestore){
        
        let rcg = RandomCodeGenerator()
        let code = rcg.GenerateCode()
        
        // check if that companyID already exists in companies, if not then go ahead else generate new code
        db.collection("companies").document(code).getDocument { (document, error) in
            if error != nil {
                print("startbusiness Document Error => ", error!)
            } else {
                if let document = document {
                    if document.exists {
                        //call again and it will generate a new code
                        self.startBussiness(db: db)
                    } else {
                        // This adds the user to users with their new companyID
                        db.collection("users").document(self.user!.uid).setData(["companyID": code])
                        
                        // however we also need to add them to the companies
                        // collection with all of the required information to start their business
                        let employeeCollection = db.collection("companies").document(code).collection("employees").document(self.user.uid)
                        employeeCollection.setData(["jobTitle" : ""])
                        employeeCollection.setData(["department" : "admin"])
                        employeeCollection.setData(["position" : "supervisor"])
                        
                        db.collection("companies").document(code).setData(["exists" : true])
                        employeeCollection.setData(["exists" : true])
                        
                        
                        let departmentDoc = db.collection("companies").document(code).collection("departments").document("admin")
                        departmentDoc.collection("employees").document(self.user.uid).setData(["position" : "supervisor"])
                        
                        db.collection("companies").document(code).setData(["exists" : true])
                        departmentDoc.setData(["exists" : true])
                        
                        
                        let actionsCollection = db.collection("companies").document(code).collection("actions")
                        actionsCollection.document("absent").setData(["exists" : true])
                        actionsCollection.document("meetings").setData(["exists" : true])
                        actionsCollection.document("expenses").setData(["exists" : true])
                        actionsCollection.document("vacations").setData(["exists" : true])
                        actionsCollection.document("feedback").setData(["exists" : true])
                        actionsCollection.document("training").setData(["exists" : true])
                    }
                }
            }
        }
    }
    
    
}

