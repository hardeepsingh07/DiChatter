//
//  searchController.swift
//  DiChatter
//
//  Created by Hardeep Singh on 12/18/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class searchController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tView: UITableView!
    @IBOutlet weak var searchLabel: UIButton!
    
    var searchControl: UISearchController!
    
    var ref: FIRDatabaseReference!
    let defaults = UserDefaults.standard
    
    var firebaseUsers = [UserInfo]()
    var filteredUsers = [UserInfo]()
    var friends = [String]()
    var requested = [String]()
    var currentUser: UserInfo!
    
    var searching = false
    
    override func viewWillAppear(_ animated: Bool) {
        //Intialize the databse
        ref = FIRDatabase.database().reference()
        
        //Get current user information from NSUserDefaults
        //get current user info
        if let savedPeople = defaults.object(forKey: "user") as? Data {
            currentUser = (NSKeyedUnarchiver.unarchiveObject(with: savedPeople) as! [UserInfo])[0]
        }
        
        //Make Firebase call for all user
        getAllUserData()
        getCurrentFriends()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //load after the data retrival
        searchLabel.alpha = 0.0
        tView.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Animate Label
        animateSearchLabel()
        
        //Animate Table
        animateTable()
        
        //Reload Table
        self.filteredUsers = self.firebaseUsers
        tView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sCell", for: indexPath) as! searchTableViewCell
        
        var userItem: UserInfo
        userItem = self.filteredUsers[indexPath.row]
        
        cell.sName.text = userItem.getName()
        cell.sEmail.text = userItem.getEmail()
        cell.sAdd.tag = indexPath.row
        cell.sAdd.addTarget(self, action: #selector(searchController.addUser(_:)), for: .touchUpInside)
        
        //set button image for friends
        for s in friends {
            if(userItem.getId() == s) {
                cell.sAdd.setImage(#imageLiteral(resourceName: "friendGrey"), for: .normal)
                cell.sAdd.isEnabled = false
            } 
        }
        
        //Set button image for already requested        

        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUsers = searchText.isEmpty ? firebaseUsers : firebaseUsers.filter({( userInfo: UserInfo ) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return userInfo.getEmail().range(of: searchText, options: .caseInsensitive) != nil
        })
        tView.reloadData()
    }
    
    
    @IBAction func addUser(_ sender: UIButton) {
        var userItem: UserInfo
        userItem = self.filteredUsers[sender.tag]
        sender.setImage(#imageLiteral(resourceName: "timeGrey"), for: .normal)
        
        //add to requested people list
        self.ref.child("Users").child(self.currentUser.getId()).child("Requested")
            .setValue([userItem.getId()])
        
        //request the selected user 
        self.ref.child("Users").child(userItem.getId()).child("Requests").child(currentUser.getId())
            .setValue(["Name": self.currentUser.getName(), "Email": self.currentUser.getEmail()])
        
        //show confirmation
        makeAlert(title: "Info", message: ("Request Sent: " + userItem.getName()))
    }
    
    func animateSearchLabel() {
        searchLabel.center.x = self.view.frame.width
        searchLabel.alpha = 1.0
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0.1, options: [],
                       animations: ({
                        self.searchLabel.center.x = self.view.frame.width / 2
                       }), completion: nil)
    }
    
    func animateTable() {
        tView.center.y = self.view.frame.height + 100
        tView.alpha = 1.0
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: [],
                       animations: ({
                        self.tView.center.y = self.view.frame.height - 300
                       }), completion: nil)
    }
    
    // Get all users from database
    func getAllUserData() {
        ref.child("Users").observe(.value, with: { (snapshot) in
            for user in snapshot.children {
                let userId = ((user as! FIRDataSnapshot).key)
                let name = ((user as! FIRDataSnapshot).value! as! NSDictionary)["Name"] as! String
                let email = ((user as! FIRDataSnapshot).value! as! NSDictionary)["Email"] as! String
                
                let userInfo = UserInfo(id: userId, name: name, email: email)
                self.firebaseUsers.append(userInfo)
            }
        }) { (error) in
            self.makeAlert(title: "Ok", message: error.localizedDescription)
        }
    }
    
    //get User Friends
    func getCurrentFriends() {
        ref.child("Users").child(currentUser.getId()).child("Friends").observe(.value, with: { (snapshot) in
            for user in snapshot.children {
                let fId = (user as! FIRDataSnapshot).key
                self.friends.append(fId)
            }
        }) { (error) in
            self.makeAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
//    //get User requested list
//    func getUserRequested() {
//        ref.child("Users").child(currentUser.getId()).child("Requested").observe(.value, with: { (snapshot) in
//            for user in snapshot.children {
//                self.requested.append((user as AnyObject).value)
//            }
//        }) { (error) in
//            self.makeAlert(title: "Error", message: error.localizedDescription)
//        }
//    }

    //make alerts
    func makeAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated:true, completion: nil)
    }
}
