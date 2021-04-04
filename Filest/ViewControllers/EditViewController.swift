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
    @IBOutlet weak var saveButton: UIButton!
    
    var user: User!
    var verificationId: String?
    var code: String?
    var fs: Firestore!
    var companyID: String?
    var employeeData: DocumentReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up text fields and image if available
        self.user = Auth.auth().currentUser
        fs = Firestore.firestore()
        setProfilePhoto()
        fs.collection("users").document(user!.uid).getDocument { (document, error) in
            if error != nil {
                print("joinbusiness Document Error => ", error!)
            } else {
                if let document = document {
                    if document.exists {
                        self.companyID =  (document.get("companyID") as! String)
                        self.employeeData = self.fs.collection("companies").document(self.companyID!).collection("employees").document(self.user!.uid)
                        self.setUserInformation();
                    }
                }
            }
        }
        
        phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: "Phone number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 171.0/255.0, green: 171.0/255.0, blue: 180.0/255.0, alpha: 1)])
        jobTitleTextField.attributedPlaceholder = NSAttributedString(string: "Job Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 171.0/255.0, green: 171.0/255.0, blue: 180.0/255.0, alpha: 1)])
        
        saveButton.layer.cornerRadius = 23
        saveButton.clipsToBounds = true
        
        self.hideKeyboardWhenTappedAround()
    }
    
    //open image picker
    @IBAction func Edit(_ sender: UIButton){
        self.showAlert()
    }
    
    // Save changes and transition home
    @IBAction func Save(_ sender: UIButton) {
        var firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let firstLetterFirstName = firstName.first
        firstName.removeFirst()
        firstName = (firstLetterFirstName?.uppercased())! + firstName
        
        var lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let firstLetterLastName = lastName.first
        lastName.removeFirst()
        lastName = (firstLetterLastName?.uppercased())! + lastName
        
        let jobTitle    = jobTitleTextField.text
        let phoneNumber = phoneNumberTextField.text
        let email       = emailTextField.text
        
        let delegate = UIApplication.shared.delegate as! AppDelegate

        //save personal data
        let changeRequest = self.user.createProfileChangeRequest()
        changeRequest.displayName = (firstName) + " " + (lastName)
       
        changeRequest.commitChanges { (error) in
            if error != nil {
                print (error as Any)
            }
        }
        
        employeeData.setData(["jobTitle": jobTitle ?? "none"], merge: true)
        employeeData.setData(["phoneNumber": phoneNumber ?? "none"], merge: true)
        employeeData.setData(["givenName" : firstName], merge: true)
        employeeData.setData(["familyName" : lastName], merge: true)
        employeeData.setData(["email" : email ?? "none"], merge: true)
        
        // save image
        let storageRef = Storage.storage().reference().child((user?.uid ?? "")+".png")
        
        if let uploadData = profileImage.image?.pngData(){
            
            delegate.profileCache.setObject(profileImage.image!, forKey: ((self.user?.uid ?? "")+".png") as NSString)
            
            storageRef.putData(uploadData, metadata: nil
                               , completion: { (metadata, error) in
                                if error != nil {
                                    print ("error")
                                }
            })
        }
        
        self.TransitiontoProfile()
    }
    
    @IBAction func Cancel(_ sender: UIButton) {
        self.TransitiontoProfile()
    }

    func TransitiontoProfile(){

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)

    }
    
    func setUserInformation(){
        
        let namesArray = user?.displayName?.split(separator: " ")
        self.firstNameTextField.text = String(namesArray![0])
        self.lastNameTextField.text  = String(namesArray![1])
        self.emailTextField.text =           (user?.email)!
     
        employeeData.getDocument { (document, error) in
            if error != nil {
                print("join business Document Error => ", error!)
            } else {
            
                if let document = document {
                    
                    if document.exists {
                
                        let jobTitle = document.get("jobTitle") as! String?
                        let phoneNumber = document.get("phoneNumber")  as! String?
                        
                        if (jobTitle    != "none" && jobTitle     != "" && jobTitle     != nil) {  self.jobTitleTextField.text = jobTitle       }
                        if (phoneNumber != "none" && phoneNumber  != "" && phoneNumber  != nil) {  self.phoneNumberTextField.text = phoneNumber }
                        
                    }
                }
            }
        }
    }
    
    func setProfilePhoto(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let storageRef = Storage.storage().reference().child((user?.uid ?? "")+".png")
        
        if let cachedImage = delegate.profileCache.object(forKey: ((user?.uid ?? "")+".png") as NSString) {
            self.profileImage.image = cachedImage
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
            self.profileImage.clipsToBounds = true
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
                }
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
            let ImageWidth = image.size.width
            let ImageHeight = image.size.height
            let scale = ImageWidth / 200
            self?.profileImage.image = image.sd_resizedImage(with: CGSize(width: ImageWidth / scale, height: ImageHeight / scale), scaleMode: .aspectFill)
                
            self?.profileImage.layer.cornerRadius = self!.profileImage.frame.size.width / 2
            self?.profileImage.clipsToBounds = true
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
