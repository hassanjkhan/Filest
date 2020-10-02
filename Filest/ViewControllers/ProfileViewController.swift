//
//  ProfileViewController.swift
//  Filest
//
//  Created by admin on 2020-07-09.
//  Copyright © 2020 Z-Lux. All rights reserved.
//

import UIKit
import FirebaseAuth
class ProfileViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
  
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { get { return .portrait } }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        errorLabel.alpha = 0
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
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        
         (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
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
