//
//  chatController.swift
//  DiChatter
//
//  Created by Hardeep Singh on 12/18/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class chatController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tView: UITableView!
    @IBOutlet weak var screenLabel: UIButton!
    
    var message = [MessageInfo]()
    var messageCatalog = [String: MessageInfo]()
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get the chats
        observeChats()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cCell", for: indexPath)
        
        let messageInfo = message[indexPath.row]
        //need that partner id logic
        if let toID = messageInfo.chatPartnerId() {
            ref = FIRDatabase.database().reference()
            self.ref.child("Users").child(toID).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                cell.textLabel?.text = value?["Name"] as? String ?? ""
            })
        }
        cell.detailTextLabel?.text = messageInfo.getMessageValue()
        return cell
    }
    
    func getUser(id: String) -> String {
        ref = FIRDatabase.database().reference()
        var userName: String!
        self.ref.child("Users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            userName = value?["Name"] as? String ?? ""
        })
        print(userName)
        return userName
    }
    
    func observeChats() {
        ref = FIRDatabase.database().reference()
        let currentID = FIRAuth.auth()?.currentUser?.uid
        self.ref.child("UserMessages").child(currentID!).observe(.childAdded, with: { (snapshot) in
            let mID = snapshot.key
            //Query Messages to find the approriate message via reference Id (mID)
            self.ref.child("Messages").child(mID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let mToID = dictionary["toID"] as? String ?? ""
                    let mFromID = dictionary["fromID"] as? String ?? ""
                    let mTimeStamp = dictionary["timeStamp"] as? Int ?? 0
                    let mMessage = dictionary["messageValue"] as? String ?? ""
                    
                    //add to array
                    let cM = MessageInfo(toID: mToID, fromID: mFromID, timeStamp: mTimeStamp, messageValue: mMessage)
                    self.messageCatalog[mToID] = cM
                    self.message = Array(self.messageCatalog.values)

                    //reload table
                    self.tView.reloadData()
                }
            }, withCancel: nil)
        }, withCancel: nil)
        
    }
}
