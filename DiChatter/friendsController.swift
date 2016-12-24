//
//  friendsController.swift
//  DiChatter
//
//  Created by Hardeep Singh on 12/18/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class friendsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var ref: FIRDatabaseReference!
    @IBOutlet weak var tView: UITableView!
    @IBOutlet weak var labelButton: UIButton!
    let defaults = UserDefaults.standard
    
    var userFriends = [UserInfo]()
    var currentUser: UserInfo!
    
    //Start Loading Data before View
    override func viewWillAppear(_ animated: Bool) {
        //Intialize the Database
        ref = FIRDatabase.database().reference()
        
        //get current user info
        if let savedPeople = defaults.object(forKey: "user") as? Data {
            currentUser = (NSKeyedUnarchiver.unarchiveObject(with: savedPeople) as! [UserInfo])[0]
        }
        
        //Get Data for Request
        getUserData()
    }
    
    //Hide attributes till data is retrieved
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load after the data retrival
        labelButton.alpha = 0.0
        tView.alpha = 0.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Animate ScreenLabel
        self.animateFriendLabel()
        
        //reload table
        self.tView.reloadData()
        
        //Animate TableView
        self.animateTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func animateFriendLabel() {
        labelButton.center.x = self.view.frame.width - 400
        labelButton.alpha = 1.0
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: [],
                       animations: ({
                        self.labelButton.center.x = self.view.frame.width - 190
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fCell", for: indexPath) as! friendTableViewCell
        
        cell.fName.text = userFriends[indexPath.row].getName()
        cell.fEmail.text = userFriends[indexPath.row].getEmail()
        cell.fDelete.tag = indexPath.row
        
        cell.fDelete.addTarget(self, action: #selector(friendsController.deleteUser(_:)), for: .touchUpInside)
        return cell
    }
    
    @IBAction func deleteUser(_ sender: UIButton) {
        let userInfo = userFriends[sender.tag]
        let alertController = UIAlertController(title: "Delete", message: "User will be removed from friend list permanently", preferredStyle: .alert)
        let delete = UIAlertAction(title: "Delete It", style: .destructive) { (action) in
            //remove from current user friend list
            self.ref.child("Users").child(self.currentUser.getId()).child("Friends").child(userInfo.getId()).removeValue()
            
            //remove current user from other user friend list 
            self.ref.child("Users").child(userInfo.getId()).child("Friends").child(self.currentUser.getId()).removeValue()
            
            self.userFriends.remove(at: sender.tag)
            self.tView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(delete)
        alertController.addAction(cancel)
        self.present(alertController, animated:true, completion: nil)
    }
    
    //get User Requests
    func getUserData() {
        ref.child("Users").child(currentUser.getId()).child("Friends").observe(.value, with: { (snapshot) in
            for user in snapshot.children {
                let fId = (user as! FIRDataSnapshot).key
                
                let dictionary = (user as! FIRDataSnapshot).value! as! NSDictionary
                let fName = dictionary["Name"] as! String
                let fEmail = dictionary["Email"] as! String
                
                let userInfo = UserInfo(id: fId, name: fName, email: fEmail)
                self.userFriends.append(userInfo)
            }
        }) { (error) in
            self.makeAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    //make alerts
    func makeAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
