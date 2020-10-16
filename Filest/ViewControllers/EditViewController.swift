//
//  EditViewController.swift
//  Filest
//
//  Created by admin on 2020-10-15.
//  Copyright © 2020 Z-Lux. All rights reserved.
//

import UIKit
import Photos
import FirebaseAuth
import Firebase


class EditViewController: UIViewController {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var jobTitleTextField: UITextField!
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up text fields and image if available
        setUserInformation();
    }
    
    //open image picker
    @IBAction func Edit(_ sender: UIButton){
        self.showAlert()
    }
    
    // Save changes and transition home
    @IBAction func Save(_ sender: UIButton) {
        //let firstName   = firstNameTextField.text
        //let lastName    = lastNameTextField.text
        //let jobTitle    = jobTitleTextField.text
        //let phoneNumber = phoneNumberTextField.text
        
        let user = Auth.auth().currentUser
        let storageRef = Storage.storage().reference().child((user?.uid ?? "")+".png")
        let compressedImage = profileImage.image?.sd_resizedImage(with: CGSize(width: 1200, height: 1200), scaleMode: .fill)
        if let uploadData = compressedImage!.pngData(){
            
            storageRef.putData(uploadData, metadata: nil
                               , completion: { (metadata, error) in
                                if error != nil {
                                    print ("error")
                                } else {
//                                    storageRef.downloadURL { (url, error) in
//                                        let changeRequest = user?.createProfileChangeRequest()
//                                        //changeRequest?.displayName = (firstName ?? "") + " " + (lastName ?? "")
//                                        changeRequest?.photoURL = (url?.absoluteURL)!
//
//                                        changeRequest?.commitChanges { (error) in
//                                          // ...
//                                            print(url!)
//                                        }
//
//                                    }
                                }
                
            })
        }

        self.TransitiontoProfile()
    }
    
    
    
    func TransitiontoProfile(){

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        //vc.modalPresentationStyle = .fullScreen
        //vc.modalTransitionStyle = .flipHorizontal
        //present(vc, animated: true)
    }
    
    
    func setUserInformation(){
        //let ref = Firestore.firestore()
        //ref = Database.database().reference()
        let user = Auth.auth().currentUser
        let namesArray = user?.displayName?.split(separator: " ")
        self.firstNameTextField.text = String(namesArray![0])
        self.lastNameTextField.text  = String(namesArray![1])
        self.emailTextField.text =           (user?.email)!
        if user?.phoneNumber != nil {
            self.phoneNumberTextField.text = user?.phoneNumber
        }
        //self.jobTitleTextField.text = user?.value(forKey: "job") as? String
        

        
        let storageRef = Storage.storage().reference().child((user?.uid ?? "")+".png")
        storageRef.downloadURL { (url, error) in
            if error != nil {
                
            } else {
                let imageUrlString = url?.absoluteString

                let imageUrl = URL(string: imageUrlString!)!

                let imageData = try! Data(contentsOf: imageUrl)

                self.profileImage.image = UIImage(data: imageData)
                
                //self.profileImage.transform = CGAffineTransform(rotationAngle: (90.0 * .pi) / 180.0)
                
                //self.profileImage.setRounded()
                self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
                self.profileImage.clipsToBounds = true
            }
            
            
        }
    }
    
    

}

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //Show alert to selected the media source type.
    private func showAlert() {

        let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
   
    }
    
    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {

        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {

            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    //MARK:- UIImagePickerViewDelegate.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            self.dismiss(animated: true) { [weak self] in
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            //Setting image to your image view
            self?.profileImage.image = image
                
            self?.profileImage.layer.cornerRadius = self!.profileImage.frame.size.width / 2
            self?.profileImage.clipsToBounds = true
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //https://stackoverflow.com/questions/52399079/accessing-the-camera-and-photo-library-in-swift-4
}
