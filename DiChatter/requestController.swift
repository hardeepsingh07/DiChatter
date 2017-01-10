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
        requestButtonOutlet.alpha = 0.0
        tView.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Animate ScreenLabel and Table
        self.animateRequestLabel()
        self.animateTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rCell", for: indexPath) as! requestTableViewCell
        
        cell.rName.text = userRequests[indexPath.row].name
        cell.rEmail.text = userRequests[indexPath.row].email
        cell.rAccept.tag = indexPath.row
        cell.rDecline.tag = indexPath.row
        
        cell.rAccept.addTarget(self, action: #selector(requestController.accept(_:)), for: .touchUpInside)
        cell.rDecline.addTarget(self, action: #selector(requestController.decline(_:)), for: .touchUpInside)
        return cell
    }
    
    @IBAction func accept(_ sender: UIButton) {
        let userInfo = userRequests[sender.tag]
        
        //move to friends list
        self.ref.child("Users").child(self.currentUser.id!).child("Friends").child(userInfo.id!)
            .setValue(["Name": userInfo.name!, "Email": userInfo.email!])
        
        //add to current user to requestee friend list
        self.ref.child("Users").child(userInfo.id!).child("Friends").child(self.currentUser.id!)
            .setValue(["Name": self.currentUser.name!, "Email": self.currentUser.email!])
        
        //remove from request list
        self.ref.child("Users").child(self.currentUser.id!).child("Requests").child(userInfo.id!).removeValue()
        
        //remove current user from requestee requsted list
        self.ref.child("Users").child(userInfo.id!).child("Requested").child(currentUser.id!).removeValue()
        
        //remove from table
        self.userRequests.remove(at: sender.tag)
        self.tView.reloadData()
        
        //show success alert
        self.makeAlert(title: "Success", message: "You are now friends with " + userInfo.name!)
    }
    
    @IBAction func decline(_ sender: UIButton) {
        let userInfo = userRequests[sender.tag]
        let alertController = UIAlertController(title: "Delete", message: "Request will be deleted permanently. Requestee will be given another chance to request.", preferredStyle: .alert)
        let delete = UIAlertAction(title: "Delete It", style: .destructive) { (action) in
            //remove from request list and list
            self.ref.child("Users").child(self.currentUser.id!).child("Requests").child(userInfo.id!).removeValue()
            
            //remove current user from requestee requsted list
            self.ref.child("Users").child(userInfo.id!).child("Requested").child(self.currentUser.id!).removeValue()
            
            self.userRequests.remove(at: sender.tag)
            self.tView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(delete)
        alertController.addAction(cancel)
        self.present(alertController, animated:true, completion: nil)
    }
    
    //get User Requests
    func getUserData() {
        ref.child("Users").child(currentUser.id!).child("Requests").observe(.value, with: { (snapshot) in
            for user in snapshot.children {
                let fId = (user as! FIRDataSnapshot).key
                
                let dictionary = (user as! FIRDataSnapshot).value! as! NSDictionary
                let fName = dictionary["Name"] as! String
                let fEmail = dictionary["Email"] as! String
                
                let userInfo = UserInfo(id: fId, name: fName, email: fEmail)
                self.userRequests.append(userInfo)
                
                //reload table
                self.tView.reloadData()
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
    
    //Animations
    func animateRequestLabel() {
        requestButtonOutlet.center.x = self.view.frame.width + 150
        requestButtonOutlet.alpha = 1.0
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: [],
                       animations: ({
                        self.requestButtonOutlet.center.x = self.view.frame.width - 185
                       }), completion: nil)
    }
    
    func animateTable() {
        tView.center.y = self.view.frame.height + 100
        tView.alpha = 1.0
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: [],
                       animations: ({
                        self.tView.center.y = self.view.frame.height - 300
                       }), completion: nil)
    }
}
