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
    @IBOutlet weak var TopTabView: UIView!
    @IBOutlet weak var editButton: UIButton!
    
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
        self.TopTabView.bottomAnchor.constraint(equalTo: jobTitle.bottomAnchor, constant: 10.0).isActive = true
        
        
        
        
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
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        self.name.text = user?.displayName
        self.emailButton.setTitle("    " + (user?.email)!, for: .normal)
        
        let storageRef = Storage.storage().reference().child((user?.uid ?? "")+".png")
        let group = DispatchGroup()
        group.enter()
        if let cachedImage = delegate.profileCache.object(forKey: ((user?.uid ?? "")+".png") as NSString) {
            self.profileImage.image = cachedImage
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
            self.profileImage.clipsToBounds = true
            group.leave()
        } else {
            
            storageRef.downloadURL { (url, error) in
                if error != nil {
                    
                } else {
                    let imageUrlString = url?.absoluteString

                    let imageUrl = URL(string: imageUrlString!)!

                    let imageData = try! Data(contentsOf: imageUrl)

                    self.profileImage.image = UIImage(data: imageData)
                
                    delegate.profileCache.setObject(self.profileImage.image!, forKey: ((self.user?.uid ?? "")+".png") as NSString)
                    
                    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
                    self.profileImage.clipsToBounds = true
                    group.leave()
                }
                
            }
        }
        
        
        
        group.notify(queue: .main) {
            //set colors based images
            var primaryColor = self.profileImage.image?.getColors().primary.withAlphaComponent(0.75)
            var colors = primaryColor?.rgba
            if (colors?.red == 1 && colors?.green == 1 && colors?.blue == 1){
                primaryColor = self.profileImage.image?.getColors().secondary.withAlphaComponent(0.75)
                colors = primaryColor?.rgba
            }
            if (colors?.red == 1 && colors?.green == 1 && colors?.blue == 1){
                primaryColor = self.profileImage.image?.getColors().background.withAlphaComponent(0.75)
                colors = primaryColor?.rgba
            }
            
            
            
            if (colors!.red < 0.1 && colors!.green < 0.1 && colors!.blue < 0.1){
                primaryColor = UIColor.init(red: 90/255, green: 90/255, blue: 90/255, alpha: 1)
            } else if (colors!.blue > 0.5){
                self.editButton.setTitleColor(.white, for: .normal)
            }
   
            self.TopTabView.backgroundColor =  primaryColor ?? .systemGray
            self.phoneButton.backgroundColor = primaryColor ?? .systemGray
            self.emailButton.backgroundColor = primaryColor ?? .systemGray
            
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
                        
                        self.fs.collection("companies").document(self.businessCode).collection("employees").document(self.user!.uid).getDocument { (document, error) in
                            if error != nil {
                                print("set user info Document Error => ", error!)
                            } else {
                                if let document = document {
                                    if document.exists {
                                        let phoneNumber = "    " + (document.get("phoneNumber") as! String)
                                        if document.get("phoneNumber") as! String != "none"{
                                            self.phoneButton.setTitle(phoneNumber, for: .normal)
                                        } else {
                                            self.phoneButton.setTitle("    (000) - 000 - 0000", for: .normal)
                                        }
                                        if document.get("jobTitle") as! String != "none"{
                                            self.jobTitle.text = (document.get("jobTitle") as! String)
                                            self.jobTitle.alpha = 1
                                        }
                                        
                                    }
                                }
                            }
                        }
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
        let joinAlert = UIAlertController(title: "Enter the company code", message: "This should be a code with 7 letters.", preferredStyle: .alert)
        let database = Firestore.firestore()
        
        alert.addAction(UIAlertAction(title: "Start a business", style: .default, handler:   { action in

            // adding user to users with their companyID create a new collection in companies collection containing all the basics for actions
            self.startBussiness(db: database)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Join a business", style: .default, handler: { action in
            
            joinAlert.addTextField { (textField) in
                textField.placeholder = "ADCDEFG"
            }
            
            joinAlert.addAction(UIAlertAction(title: "Join", style: .default, handler:   { action in
                
                //add another alert that asks for code, checks if code exists, if it does then adds user to business
                let code = joinAlert.textFields![0].text
                
                if code != nil && code != "" {
                    self.joinBusiness(code: code ?? "", db: database)
                } else {
                    self.failedAlert()
                }
                
            }))
            
            self.present(joinAlert, animated: true)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:  { action in}))
        
        self.present(alert, animated: true)
        
    }
    
    func joinBusiness(code: String, db: Firestore){
        db.collection("companies").document(code).getDocument { (document, error) in
            if error != nil {
                print("joinbusiness Document Error => ", error!)
            } else {
                if let document = document {
                    if document.exists {
                       
                        db.collection("users").document(self.user!.uid).setData(["companyID": code])
                        
                        // however we also need to add them to the companies
                        // collection with all of the required information to start their business
                        let employeeCollection = db.collection("companies").document(code).collection("employees").document(self.user.uid)
                        employeeCollection.setData(["jobTitle" : "none"], merge: true)
                        employeeCollection.setData(["department" : "none"], merge: true)
                        employeeCollection.setData(["position" : "employee"], merge: true)
                        employeeCollection.setData(["phoneNumber" : "none"], merge: true)
                        
                        
                        self.setUserInformation()
                        self.beginButton.isEnabled = false
                        self.beginButton.alpha = 0
                        
                        
                        let successAlert = UIAlertController(title: "You've Joined!", message: "", preferredStyle: .alert)
                        successAlert.addAction(UIAlertAction(title: "Great!", style: .default, handler:   { action in }))
                        self.present(successAlert, animated: true)
                        
                        
                        
                    } else {
                        self.failedAlert()
                    }
                }
            }
        }
    }
    
    func failedAlert(){
        let failedAlert = UIAlertController(title: "Not Found", message: "That code does not exist please try again", preferredStyle: .alert)
        failedAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler:   { action in }))
        self.present(failedAlert, animated: true)
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
                        // call again and it will generate a new code
                        self.startBussiness(db: db)
                    } else {
                        // This adds the user to users with their new companyID
                        db.collection("users").document(self.user!.uid).setData(["companyID": code])
                        
                        // however we also need to add them to the companies
                        // collection with all of the required information to start their business
                        let employeeData = db.collection("companies").document(code).collection("employees").document(self.user.uid)
                        employeeData.setData(["jobTitle" : "none","department" : "admin","phoneNumber" : "none"], merge: true)
                        
                        let namesArray = self.user.displayName?.split(separator: " ")
                        let firstName  = String(namesArray![0])
                        let lastName   = String(namesArray![1])
                        
                        employeeData.setData(["givenName" : firstName,"familyName" : lastName, "email" : self.user.email ?? " "], merge: true)
                        //employeeData.setData(["familyName" : lastName], merge: true)
                        //employeeData.setData(["email" : self.user.email ?? " "], merge: true)
                        
                        db.collection("companies").document(code).setData(["exists" : true])
                        
                        let departmentDoc = db.collection("companies").document(code).collection("departments").document("admin")
                        departmentDoc.collection("employees").document(self.user.uid).setData(["position" : "supervisor"])
                        
                        db.collection("companies").document(code).setData(["exists" : true])
                        departmentDoc.setData(["exists" : true])
                        
//                        db.collection("companies").document(code).collection("absent").addDocument(data:
//                                                                                                    ["Description" : "I am sick",
//                                                                                                     "From" : self.user!.uid,
//                                                                                                     "To" : [self.user!.uid],
//                                                                                                     "Date From" : Date.init(),
//                                                                                                     "Date To" : Date.init()])
                            
                        
                        self.setUserInformation()
                        self.beginButton.isEnabled = false
                        self.beginButton.alpha = 0
                        
                        
                        let successAlert = UIAlertController(title: "You've Started a Business!", message: "Share your company ID to your employees to have them join your business!", preferredStyle: .alert)
                        successAlert.addAction(UIAlertAction(title: "Great!", style: .default, handler:   { action in }))
                        self.present(successAlert, animated: true)
                    }
                }
            }
        }
    }
    
    
}

