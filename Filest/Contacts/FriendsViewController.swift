

import UIKit
import ContactsUI
import FirebaseDatabase
import Firebase
import FirebaseAuth


class FriendsViewController: UITableViewController {
    var fs: Firestore!
    var user: User!
    @IBOutlet var table: UITableView!
    var businessCode: String!
    var friendsList = Friend.defaultContacts()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //navigationItem.titleView = UIImageView(image: UIImage(named: "RWConnectTitle")!)
    user = Auth.auth().currentUser
    fs = Firestore.firestore()
    self.addContacts()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.tintColor = .white
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if
      segue.identifier == "EditFriendSegue",
      // 1
      let cell = sender as? FriendCell,
      let indexPath = tableView.indexPath(for: cell),
      let editViewController = segue.destination as? EditFriendTableViewController {
        let friend = friendsList[indexPath.row]
        // 2
        let store = CNContactStore()
        // 3
        let predicate = CNContact.predicateForContacts(matchingEmailAddress: friend.workEmail)
        // 4
        let keys = [CNContactPhoneNumbersKey as CNKeyDescriptor]
        // 5
        if
          let contacts = try? store.unifiedContacts(matching: predicate, keysToFetch: keys),
          let contact = contacts.first,
          let contactPhone = contact.phoneNumbers.first {
          // 6
            friend.storedContact = contact.mutableCopy() as? CNMutableContact
            friend.phoneNumberField = contactPhone
            friend.identifier = contact.identifier
        }
        editViewController.friend = friend
    }
  }
    
    @IBAction private func addFriends(sender: UIBarButtonItem) {
        // 1
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        // 2
        contactPicker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0")
        present(contactPicker, animated: true)
    }
    
    
    func addContacts(){
        let docref =  fs.collection("users").document(user!.uid)

        docref.getDocument { (document, error) in
            if error != nil {
                print("Friend Document Error => ", error!)
            } else {
                if let document = document {
                    if document.exists {
                        self.businessCode = (document.get("companyID") as! String)
                        self.fs.collection("companies").document(self.businessCode).collection("employees").getDocuments { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents getEmployeesData: \(err)")
                            } else {
                                //self.table.beginUpdates()
                                let delegate = UIApplication.shared.delegate as! AppDelegate
                                for document in querySnapshot!.documents {
                                    let userId      = document.documentID
                                    let givenName   = document.get("givenName") as! String
                                    let familyname  = document.get("familyName") as! String
                                    let email       = document.get("email") as! String
                                    let storageRef  = Storage.storage().reference().child((userId)+".png")
                                    
                                    if let cachedImage = delegate.contactsCache.object(forKey: ((userId)+".png") as NSString) {
                                       
                                        self.friendsList.append(Friend(firstName: givenName , lastName: familyname , workEmail: email , profilePicture: cachedImage ))
                                        self.friendsList.sort { (Friend1: Friend, Friend2: Friend) -> Bool in
                                            return Friend1.firstName.prefix(0) < Friend2.firstName.prefix(0)
                                        }
                                        
                                        self.table.reloadData()

                                    } else {
                                        storageRef.downloadURL { (url, error) in
                                            if error == nil {
                                                let imageUrlString = url?.absoluteString
                                                let imageUrl = URL(string: imageUrlString!)
                                                let imageData = try! Data(contentsOf: imageUrl!)
                                                
                                                if imageUrl != nil {
                                                    delegate.contactsCache.setObject(UIImage(data: imageData)!, forKey: ((userId)+".png") as NSString)
                                                }
                                                self.friendsList.append(Friend(firstName: givenName, lastName: familyname, workEmail: email, profilePicture: UIImage(data: imageData) ?? UIImage(named: "user")))

                                                self.friendsList.sort { (Friend1: Friend, Friend2: Friend) -> Bool in
                                                    return Friend1.firstName.prefix(0) < Friend2.firstName.prefix(0)
                                                }
                                                self.table.reloadData()
                                            } else {
                                                self.friendsList.append(Friend(firstName: givenName, lastName: familyname, workEmail: email, profilePicture: UIImage(named: "user")))

                                                self.friendsList.sort { (Friend1: Friend, Friend2: Friend) -> Bool in
                                                    return Friend1.firstName.prefix(0) < Friend2.firstName.prefix(0)
                                                }
                                                
                                                self.table.reloadData()
                                            }
                                        }
                                    }
                                    
                                }
                                
                                

//                                for i in 0 ..< self.friendsList.count {
//                                    self.table.insertRows(at: [IndexPath(row: i, section: 0)], with: UITableView.RowAnimation.automatic)
//                                }
                            }

                            
                        
                        }
                        
                    }
              
                }
            
            }
            
            //self.table.endUpdates()
        }
        
        
    }
    
      
      

        
    
    
}

//MARK: - UITableViewDataSource
extension FriendsViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return self.friendsList.count

  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath)
    if let cell = cell as? FriendCell {
      let friend = friendsList[indexPath.row]
      cell.friend = friend
    }
    
    return cell
  }
}

//MARK: - UITableViewDelegate
extension FriendsViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    // 1
    let friend = friendsList[indexPath.row]
    let contact = friend.contactValue
    // 2
    let contactViewController = CNContactViewController(forUnknownContact: contact)
    contactViewController.hidesBottomBarWhenPushed = true
    contactViewController.allowsEditing = false
    contactViewController.allowsActions = false
    // 3
    navigationController?.navigationBar.tintColor = UIColor(named: "blue")
    navigationController?.pushViewController(contactViewController, animated: true)
  }
}

//MARK: - CNContactPickerDelegate
extension FriendsViewController: CNContactPickerDelegate {
  func contactPicker(_ picker: CNContactPickerViewController,
                     didSelect contacts: [CNContact]) {
    //self.addContacts()
    let newFriends = contacts.compactMap { Friend(contact: $0) }
    for friend in newFriends {
      if !friendsList.contains(friend) {
        friendsList.append(friend)
      }
    }
    tableView.reloadData()
  }
}
