//
//  SignUpViewController.swift
//  Filest
//
//  Created by admin on 2020-09-01.
//  Copyright © 2020 Z-Lux. All rights reserved.
//

import MessageUI
import UIKit
import FirebaseAuth
import Firebase
import FirebaseDynamicLinks

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    
    var mailUrl: String!
    
    // make rest of text fields, test to see if it works follow tutorial further
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //hide error label
        errorLabel.alpha = 0
        
        // Rounding sign up button
        signUpButton.layer.cornerRadius = 20
        signUpButton.clipsToBounds = true
        
        //changes text placeholder color
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "first name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        lastNameTextField.attributedPlaceholder  = NSAttributedString(string: "last name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        emailTextField.attributedPlaceholder     = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        passwordTextField.attributedPlaceholder  = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        // When password changes, change log in button color
        passwordTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        //allows for tap to dismiss keyboard
        self.hideKeyboardWhenTappedAround()
        
    }

    //     Check the fields and validate that the data is correct. if everytnign is correct, this method returns nil. otherise, it returns the error message
    func validateFields() -> String? {
           
        // Check that all fields are filled in
           
        if  firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""    ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  == ""    ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)     == ""    ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  == "" {
            return "Please fill in all fields."
        }
        // add same clean and check for email
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !Utilities.isPasswordValid(cleanedPassword){
            // password isn't valid
            return "Please make sure your password is at least 8 characters, contains a special character, and a number."
        }
        
        if !Utilities.isEmailValid(cleanedEmail){
            return "Please make sure your email is formatted correctly."
        }
        
        return nil
       
    }

    @IBAction func SignUpTapped(_ sender: Any) {
        // Validate the fields
      
        let error = validateFields()
        
        if error != nil {
            // Something wrong with fields, show error message
            showError(message:error!)
        } else {
            
            //Create cleaned version of data
            var firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let firstLetterFirstName = firstName.first
            firstName.removeFirst()
            firstName = (firstLetterFirstName?.uppercased())! + firstName
            
            var lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let firstLetterLastName = lastName.first
            lastName.removeFirst()
            lastName = (firstLetterLastName?.uppercased())! + lastName
            
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let password = passwordTextField.text!//.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create User
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    
                    // There was an error in creating user
                    self.showError(message: "There was an error in creating user")//err.debugDescription)
                    
                } else {
                    
                    // user created successfuly, now store the first and last name
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = firstName + " " + lastName
                    changeRequest?.commitChanges { (error) in
                      // ...
                    }
                    
                    //send email verification
                    let user = Auth.auth().currentUser
                    
                    user?.sendEmailVerification(completion: { (error) in
                        // now that verification email has been sent and account created, open mail app!
                        
                        let alert = UIAlertController(title: "We sent you a verification email!", message: "What mail app would you like to use?", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Gmail", style: .default, handler:   { action in
                            
                            self.mailUrl = "googlegmail://"
                            self.openEmailUrl()
                            self.TransitiontoLogin()
                        }))
                        
                        alert.addAction(UIAlertAction(title: "Outlook", style: .default, handler: { action in
                            
                            self.mailUrl = "ms-outlook://"
                            self.openEmailUrl()
                            self.TransitiontoLogin()
                        }))
                        
                        alert.addAction(UIAlertAction(title: "Default", style: .default, handler:  { action in
                            
                            self.mailUrl = "mailto:"
                            self.openEmailUrl()
                            self.TransitiontoLogin()
                        }))
                        
                        self.present(alert, animated: true)
                    })
                    
                }
            }
        }
    }
     
    func transtionToHome(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let mainTabBarController = storyboard.instantiateViewController(identifier: Constants.Storyboard.homeViewController)
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    func TransitiontoLogin(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginViewController")
        
         (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
    
    func showError( message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    private func openEmailUrl() {
        
        let mailUrl = URL(string: "\(self.mailUrl ?? "")")
    
        if let mailUrl = mailUrl {
            UIApplication.shared.open(mailUrl)
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if passwordTextField.text != "" && firstNameTextField.text != "" && lastNameTextField.text != "" && emailTextField.text != ""{
            signUpButton.backgroundColor = UIColor.init(red: 0.0/255.0, green: 192.0/255.0, blue: 230.0/255.0, alpha: 1)
        }
        
    }
    
}

