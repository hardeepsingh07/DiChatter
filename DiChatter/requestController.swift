//
//  requestController.swift
//  DiChatter
//
//  Created by Hardeep Singh on 12/18/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


//Adapater/ViewController Class
class requestController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: FIRDatabaseReference!
    @IBOutlet weak var tView: UITableView!
    @IBOutlet weak var requestButtonOutlet: UIButton!
    let defaults = UserDefaults.standard
    
    var userRequests = [UserInfo]()
    var userFriends = [UserInfo]();
    
    var currentUser: UserInfo!
    
    //Start Loading Data before View
    override func viewWillAppear(_ animated: Bool) {
        //Intialize the Database
        ref = FIRDatabase.database().reference()
        
        //get current user info
        if let savedPeople = defaults.object(forKey: "user") as? Data {
            currentUser = (NSKeyedUnarchiver.unarchiveObject(with: savedPeople) as! [UserInfo])[0]
        }
        
        //Get Data for Request and Friends
        getUserData(type: "Requests")
        getUserData(type: "Friends")
    }
    
    //Hide attributes till data is retrieved
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load after the data retrival
        requestButtonOutlet.alpha = 0.0
        tView.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Animate ScreenLabel
        self.animateRequestLabel()
        
        //reload table
        self.tView.reloadData()
        
        //Animate TableView
        self.animateTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func animateRequestLabel() {
        requestButtonOutlet.center.x = self.view.frame.width + 150
        requestButtonOutlet.alpha = 1.0
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: [],
                       animations: ({
                        self.requestButtonOutlet.center.x = self.view.frame.width - 185
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
        return userRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rCell", for: indexPath) as! requestTableViewCell
        
        cell.rName.text = userRequests[indexPath.row].getName()
        cell.rEmail.text = userRequests[indexPath.row].getEmail()
        cell.rAccept.tag = indexPath.row
        cell.rDecline.tag = indexPath.row
        
        cell.rAccept.addTarget(self, action: #selector(requestController.accept(_:)), for: .touchUpInside)
        cell.rDecline.addTarget(self, action: #selector(requestController.decline(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
    @IBAction func accept(_ sender: UIButton) {
        let userInfo = userRequests[sender.tag]
        
        //move to friends list
        self.ref.child("Users").child(currentUser.getId()).child("Friends").child(userInfo.getId())
            .setValue(["Name": userInfo.getName(), "Email": userInfo.getEmail()])
        
        //add to current user to requestee friend list
        self.ref.child("Users").child(userInfo.getId()).child("Friends").child(currentUser.getId())
            .setValue(["Name": currentUser.getName(), "Email": currentUser.getEmail()])
        
        //remove from request list
        self.ref.child("Users").child(currentUser.getId()).child("Requests").child(userInfo.getId()).removeValue()
        
        //remove from table
        self.userRequests.remove(at: sender.tag)
        self.tView.reloadData()
        
        //show success alert
        self.makeAlert(title: "Success", message: "You are now friends with " + userInfo.getName())
    }
    
    @IBAction func decline(_ sender: UIButton) {
        //remove from table
        self.userRequests.remove(at: sender.tag)
        self.tView.reloadData()
    }
    
    //get User Requests 
    func getUserData(type: String) {
        ref.child("Users").child(currentUser.getId()).child(type).observe(.value, with: { (snapshot) in
            for user in snapshot.children {
                let fId = (user as! FIRDataSnapshot).key
                
                let dictionary = (user as! FIRDataSnapshot).value! as! NSDictionary
                let fName = dictionary["Name"] as! String
                let fEmail = dictionary["Email"] as! String
                
                let userInfo = UserInfo(id: fId, name: fName, email: fEmail)
                
                if(type == "Requests") {
                    self.userRequests.append(userInfo)
                } else {
                    self.userFriends.append(userInfo)
                }
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
        self.present(alertController, animated:true, completion: nil)
    }
}





//    //get all user information
//    func getUsers() {
//        ref.child("Users").observe(.value, with: { (snapshot) in
//            for user in snapshot.children {
//                let userId = ((user as! FIRDataSnapshot).key)
//                let name = ((user as! FIRDataSnapshot).value! as! NSDictionary)["Name"] as! String
//                let email = ((user as! FIRDataSnapshot).value! as! NSDictionary)["Email"] as! String
//
//                let userInfo = UserInfo()
//                userInfo.customUser(id: userId, name: name, email: email)
//                self.allUsers.append(userInfo)
//
//                print("******* GetUsers: " + userId + name + email)
//             }
//        }) { (error) in
//            self.makeAlert(title: "Ok", message: error.localizedDescription)
//        }
//    }

