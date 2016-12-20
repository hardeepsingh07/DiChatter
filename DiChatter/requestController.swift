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
    
    var friends = [String]()
    var requests = [String]()
    var allUsers = [UserInfo]()
    var requestWithInfo = [UserInfo]()
    
    //Start Loading Data before View
    override func viewWillAppear(_ animated: Bool) {
        getUsers()
        getCurrentUserData()
    }
    
    //Hide attributes till data is retrieved
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Intialize the Database
        ref = FIRDatabase.database().reference()
        
        //load after the data retrival
        requestButtonOutlet.alpha = 0.0
        tView.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //compute data
        self.computeResults()
        
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
        return requestWithInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rCell", for: indexPath) as! requestTableViewCell
        
        cell.rName.text = requestWithInfo[indexPath.row].getName()
        cell.rEmail.text = requestWithInfo[indexPath.row].getEmail()
        cell.rAccept.tag = indexPath.row
        cell.rDecline.tag = indexPath.row
        
        cell.rAccept.addTarget(self, action: #selector(requestController.accept(_:)), for: .touchUpInside)
        cell.rDecline.addTarget(self, action: #selector(requestController.decline(_:)), for: .touchUpInside)
        return cell
    }
    
    @IBAction func accept(_ sender: UIButton) {
        print("Status: Accepted" + String(sender.tag))
        //Animate ScreenLabel
        self.animateRequestLabel()
        
        //reload table
        self.tView.reloadData()
        
        //Animate TableView
        self.animateTable()
    }
    
    @IBAction func decline(_ sender: UIButton) {
        print("Status: Declined" + String(sender.tag))

    }
    
    //get all user information
    func getUsers() {
        ref.child("Users").observe(.value, with: { (snapshot) in
            for user in snapshot.children {
                let userId = ((user as! FIRDataSnapshot).key)
                let name = ((user as! FIRDataSnapshot).value! as! NSDictionary)["Name"] as! String
                let email = ((user as! FIRDataSnapshot).value! as! NSDictionary)["Email"] as! String
                
                let userInfo = UserInfo()
                userInfo.customUser(id: userId, name: name, email: email)
                self.allUsers.append(userInfo)
                
                print("******* GetUsers: " + userId + name + email)
             }
        }) { (error) in
            self.makeAlert(title: "Ok", message: error.localizedDescription)
        }
    }
    
    //get current user friends and request list
    func getCurrentUserData() {
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value directory
            let value = snapshot.value as? NSDictionary
            self.friends = value?["Friends"] as? [String] ?? []
            self.requests = value?["Requests"] as? [String] ?? []
            print("******* getCurrentUserData -> Friends: " + self.friends[0])
            print("******* getCurrentUserData -> Requests: " + self.requests[0])
        }) { (error) in
            self.makeAlert(title: "Ok", message: error.localizedDescription)
        }

    }
    
    //Compute and retrive all requestor data
    func computeResults() {
        print("******* computerResults: Start")
        for requestee in requests {
            print("********* computerResults -> Requestee: " + requestee)
            for user in allUsers {
                if(user.id == requestee) {
                    print("*************** computerResults: -> User.ID: " + user.id)
                    requestWithInfo.append(user)
                }
            }
        }
    }
    
    //make alerts
    func makeAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(action)
        self.present(alertController, animated:true, completion: nil)
    }
    
    //refresh table view
    func do_table_refresh()
    {
        DispatchQueue.main.async (execute: {
            self.tView.reloadData()
            return
        })
    }
}

/*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */
//self.makeAlert(title: "Ok", message: error.localizedDescription)

/*
 // Override to support editing the table view.
 override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
 if editingStyle == .delete {
 // Delete the row from the data source
 tableView.deleteRows(at: [indexPath], with: .fade)
 } else if editingStyle == .insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */

