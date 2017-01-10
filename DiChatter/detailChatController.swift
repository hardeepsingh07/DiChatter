//
//  detailChatController.swift
//  DiChatter
//
//  Created by Hardeep Singh on 1/3/17.
//  Copyright © 2017 Hardeep Singh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

class detailChatController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tView: UITableView!
    @IBOutlet weak var messageTextView: UITextField!
    @IBOutlet weak var nameOfUserLabel: UILabel!

    var chatPartner: UserInfo!
    var chatPartnerIDfromChat: String!
    var ref: FIRDatabaseReference!
    var messagesArray = [MessageInfo]()
    
    override func viewWillAppear(_ animated: Bool) {
        // intial setup partner data and message retrival calls
        startProcess()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cdCell", for: indexPath)
        
        let m = messagesArray[indexPath.row]
        cell.textLabel?.text = m.getMessageValue()
        
        return cell
    }
    @IBAction func sendAction(_ sender: Any) {
        let sRef = ref.child("Messages")
        let cRef = sRef.childByAutoId()
        
        //create data variable
        let toID = chatPartner.getId()
        let fromID = FIRAuth.auth()?.currentUser?.uid
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        let messageValue = messageTextView.text!
        
        //set values
        cRef.updateChildValues(["toID": toID, "fromID": fromID!, "timeStamp": timeStamp, "messageValue": messageValue])
        
        //reset the textField
        messageTextView.text = nil
        
        //make reference node for user to monitor messages
        //Give Index to current User
        ref.child("UserMessages").child(fromID!).updateChildValues([cRef.key: 1])
        
        //Give Index to Recepient User
        ref.child("UserMessages").child(toID).updateChildValues([cRef.key: 1])

    }
    
    func startProcess() {
        //get Partner data
        if(chatPartner == nil) {
            ref = FIRDatabase.database().reference()
            self.ref.child("Users").child(chatPartnerIDfromChat).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let pName = value?["Name"] as? String ?? ""
                let pEmail = value?["Email"] as? String ?? ""
                
                self.chatPartner = UserInfo(id: self.chatPartnerIDfromChat, name: pName, email: pEmail)
                
                //update UI user name label
                self.nameOfUserLabel.text = self.chatPartner.getName()
            })
        } else {
            //Update UI with user name label
            self.nameOfUserLabel.text = self.chatPartner.getName()
        }
        
        //Load all messages after current user and partner data is retrieved
        self.observeMessages()
    }

    func observeMessages() {
        ref = FIRDatabase.database().reference()
        let currentID = FIRAuth.auth()?.currentUser?.uid
        //query the UserMessage to find any new messages references
        //self.group.enter()
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
                    let messageObject = MessageInfo(toID: mToID, fromID: mFromID, timeStamp: mTimeStamp, messageValue: mMessage)
                    if self.chatPartner.getId() == messageObject.chatPartnerId()  {
                        self.messagesArray.append(messageObject)
                        self.tView.reloadData()
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
}
