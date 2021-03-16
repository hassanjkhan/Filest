//
//  LoginViewController.swift
//  Filest
//
//  Created by admin on 2020-07-09.
//  Copyright © 2020 Z-Lux. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registration: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    var user: User!
    var height: CGFloat!
    var width: CGFloat!
    var verticalConstraint: NSLayoutConstraint!
    var emailConstraint: NSLayoutConstraint!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{ get { return .portrait } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide error label
        errorLabel.alpha = 0
        
        // Rounding sign up button
        loginButton.layer.cornerRadius = 23
        loginButton.clipsToBounds = true
        
        // When password changes, change log in button color
        passwordTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        //changes text placeholder color
        emailTextField.attributedPlaceholder    = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        //allows for tap to dismiss keyboard
        self.hideKeyboardWhenTappedAround()
        
        // observes keyboard to shift all items up and down
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(notification:)),
            name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(notification:)),
            name:UIResponder.keyboardWillHideNotification, object: nil)
        
        // sets up background image to fit each phone
        height = UIScreen.main.bounds.size.height
        width = UIScreen.main.bounds.size.width
        backgroundImage.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        // sets up emailtextfield vertical constraint with view to fit for each phone
        emailConstraint = NSLayoutConstraint(item: view!, attribute: .bottom, relatedBy: .equal, toItem: emailTextField, attribute: .bottom, multiplier: 1, constant: height * 0.55)
     
        NSLayoutConstraint.activate([emailConstraint])
        
    }

    
    @IBAction func Login(_ sender: UIButton) {
        // ** check to see if authentication is valid here when backend is set up **
        // ...
        // after login is done, maybe put this in the login web service completion block

        //this does not check if it is nil or value
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                //could not sign in

                //you could add a error label to see what text is shown
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                self.user = Auth.auth().currentUser
                switch self.user?.isEmailVerified {
                case true:
                    self.setProfileCache()
                    self.TransitiontoHome()
                case false:
                    self.errorLabel.text = "Please verify your email and try again."
                    self.errorLabel.alpha = 1
                    self.Logout()
                case .none:
                    self.errorLabel.text = "None error"
                    self.errorLabel.alpha = 1
                case .some(_):
                    self.errorLabel.text = "error# 112"
                    self.errorLabel.alpha = 1
                }
            }
        }

    }
    
    func Logout() {
        let firebaseAuth = Auth.auth()
        do {
            try

                firebaseAuth.signOut()

        } catch let signOutError as NSError {

            errorLabel.text = signOutError.localizedFailureReason
            errorLabel.alpha = 1
            print ("Error signing out: %@", signOutError)

        }
    }
    
    //sets up cache for profile image
    func setProfileCache(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let storageRef = Storage.storage().reference().child((user?.uid ?? "")+".png")
        storageRef.downloadURL { (url, error) in
            if error != nil {
                print(error.debugDescription)
            } else {
                let imageUrlString = url?.absoluteString
                let imageUrl = URL(string: imageUrlString!)!
                let imageData = try! Data(contentsOf: imageUrl)
    
                delegate.profileCache.setObject(UIImage(data: imageData)!, forKey: ((self.user?.uid ?? "")+".png") as NSString)
            }
            
        }
    }
    
    func TransitiontoHome(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        
//        // This is to get the SceneDelegate object from your view controller
//        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    
    //Online Helper functions
    @objc func textFieldDidChange(_ textField: UITextField) {
        loginButton.backgroundColor = UIColor.init(red: 0.0/255.0, green: 192.0/255.0, blue: 230.0/255.0, alpha: 1)

    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        loginButton.frame.origin.y = height - keyboardFrame.size.height - loginButton.frame.height - 10
        
//       shift up
        verticalConstraint = NSLayoutConstraint(item: view!, attribute: .bottom, relatedBy: .equal, toItem: loginButton, attribute: .bottom, multiplier: 1, constant: keyboardFrame.size.height + 10)
        NSLayoutConstraint.activate([verticalConstraint])
        
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        //change color back to gray
        if passwordTextField.text == ""{
            loginButton.backgroundColor = UIColor.init(red: 167.0/255.0, green: 171.0/255.0, blue: 176.0/255.0, alpha: 1)
        }
        
        
//      shift down
        if verticalConstraint != nil {
            NSLayoutConstraint.deactivate([verticalConstraint])
            loginButton.frame.origin.y = registration.frame.origin.y - loginButton.frame.height - 5
        }
        
        
    }
    
    
    
}
