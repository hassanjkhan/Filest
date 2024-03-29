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
        if (height > 1000) {
            backgroundImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 300).isActive = true
        } else {
            backgroundImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        }
        backgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        
        // sets up emailtextfield vertical constraint with view to fit for each phone
        emailConstraint = NSLayoutConstraint(item: view!, attribute: .bottom, relatedBy: .equal, toItem: emailTextField, attribute: .bottom, multiplier: 1, constant: height * 0.55)
     
        NSLayoutConstraint.activate([emailConstraint])
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.setProfileCache()
                self.TransitiontoHome()
            }
        }

        
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
            
                self.errorLabel.text = self.signInErrorLabelHandler(error: error!)
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
                    self.errorLabel.text = "Error Signing In"
                    self.errorLabel.alpha = 1
                case .some(_):
                    self.errorLabel.text = "Error Signing In"
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
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        let emailAlert = UIAlertController(title: "Enter your email so we can send you a reset email", message: "", preferredStyle: .alert)
        
        let successfulEmailSent = UIAlertController(title: "Sent we've sent you an email to reset your password!", message: "", preferredStyle: .alert)
        
        successfulEmailSent.addAction(UIAlertAction(title: "Thanks!", style: .default))
        
        emailAlert.addTextField { (textField) in
            textField.placeholder = "name@email.com"
        }
        
        emailAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { action in
            let forgottenEmail = emailAlert.textFields![0].text ?? ""
            Auth.auth().sendPasswordReset(withEmail: forgottenEmail) { (error) in
                self.present(successfulEmailSent, animated: true)
                
            }
            
        }))
        self.present(emailAlert, animated: true)
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
    
    func signInErrorLabelHandler(error: Error) -> String{
        if let errCode = AuthErrorCode(rawValue: error._code) {
 
            switch errCode {
                case .emailChangeNeedsVerification:
                    return "Please verify your email and try again."
                case .emailAlreadyInUse:
                    return "The Email is already in use"
                case .invalidEmail:
                    return "Email is invalid"
                case .wrongPassword:
                    return "Incorrect Email or Password"
                case .userNotFound:
                    return "Incorrect Email or Password"
                default:
                    return "Error with Signing in"
            }
        }
        return ""
    }
    
    //Online Helper functions
    @objc func textFieldDidChange(_ textField: UITextField) {
        loginButton.backgroundColor = UIColor.init(red: 0.0/255.0, green: 192.0/255.0, blue: 230.0/255.0, alpha: 1)

    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        animateUp(height: keyboardFrame.height)
        
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        //change color back to gray
        if passwordTextField.text == ""{
            loginButton.backgroundColor = UIColor.init(red: 167.0/255.0, green: 171.0/255.0, blue: 176.0/255.0, alpha: 1)
        }
        animateDown()
    }
    
    
    
    @objc fileprivate func animateUp(height: CGFloat){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.loginButton.transform = CGAffineTransform(translationX: 0, y: self.loginButton.frame.height + 10 - height)
            self.emailTextField.transform       = CGAffineTransform(translationX: 0, y: -75)
            self.passwordTextField.transform    = CGAffineTransform(translationX: 0, y: -75)
            self.errorLabel.transform           = CGAffineTransform(translationX: 0, y: -75)
            self.forgotPasswordButton.transform = CGAffineTransform(translationX: 0, y: -75)
        })
    }
    
    @objc fileprivate func animateDown(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.loginButton.transform          = .identity
            self.emailTextField.transform       = .identity
            self.passwordTextField.transform    = .identity
            self.errorLabel.transform           = .identity
            self.forgotPasswordButton.transform = .identity
        })
    }

}
