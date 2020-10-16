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
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { get { return .portrait } }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        errorLabel.alpha = 0
        jobTitle.alpha = 0
        
        // Rounding sign up button
        phoneButton.layer.cornerRadius = 17
        phoneButton.clipsToBounds = true
        
        // Rounding sign up button
        emailButton.layer.cornerRadius = 17
        emailButton.clipsToBounds = true
        
        // Rounding sign up button
        signOutButton.layer.cornerRadius = 23
        signOutButton.clipsToBounds = true
        
        setUserInformation();
        
        
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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let EditViewController = storyboard.instantiateViewController(identifier: "EditViewController")
        EditViewController.modalPresentationStyle = .fullScreen
        EditViewController.modalTransitionStyle = .crossDissolve
        present(EditViewController, animated: true)
        //(UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(EditViewController)
    }
    /*
     Reads user data and sets the variables accordingly.
     Reads name, email, phone number, profile photo
     */
    func setUserInformation(){
        //let ref = Firestore.firestore()
        //ref = Database.database().reference()
        let user = Auth.auth().currentUser
        
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
            }
            
            
        }
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
