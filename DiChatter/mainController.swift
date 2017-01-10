//
//  mainController.swift
//  DiChatter
//
//  Created by Hardeep Singh on 12/15/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class mainController: UIViewController {
    
    var userInfo: UserInfo?
    var ref: FIRDatabaseReference!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Intialize Database
        ref = FIRDatabase.database().reference()
        getUserData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Action for buttons
    @IBAction func friends(_ sender: Any) {
        performSegue(withIdentifier: "mainToFriend", sender: nil)
    }
    
    @IBAction func search(_ sender: Any) {
        performSegue(withIdentifier: "mainToSearch", sender: nil)
    }
    
    @IBAction func location(_ sender: Any) {
        makeAlert(title: "Under Construction", message: "Feature will not able till next release")
    }
    
    @IBAction func chat(_ sender: Any) {
        performSegue(withIdentifier: "mainToChat", sender: nil)
    }
    
    @IBAction func settings(_ sender: Any) {
        performSegue(withIdentifier: "mainToSettings", sender: nil)
    }
    
    @IBAction func requests(_ sender: Any) {
        performSegue(withIdentifier: "mainToRequest", sender: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        performSegue(withIdentifier: "logoutToLogIn", sender: nil)
    }
    
    func getUserData() {
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value directory
            let value = snapshot.value as? NSDictionary
            
            //Get Fields
            let userName = value?["Name"] as? String ?? ""
            let userEmail = value?["Email"] as? String ?? ""
            let userNumber = value?["Number"] as? String ?? ""
            let userGender = value?["Gender"] as? String ?? ""
            
            self.userInfo = UserInfo(id: userID!, name: userName, email: userEmail, number: userNumber, gender: userGender)
            self.saveUser()
        }) { (error) in
            self.makeAlert(title: "Ok", message: error.localizedDescription)
        }
    }
    
    func makeAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(action)
        self.present(alertController, animated:true, completion: nil)
    }
    
    //save user for preferences: NSUserData
    func saveUser() {
        let userArray = [userInfo]
        let savedData = NSKeyedArchiver.archivedData(withRootObject: userArray)
        defaults.set(savedData, forKey: "user")
    }
}

