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

    var chatPartner: UserInfo!
    var ref: FIRDatabaseReference!
    var messagesArray = [MessageInfo]()
    
    override func viewWillAppear(_ animated: Bool) {
        print(chatPartner.getId(), chatPartner.getName(), chatPartner.getEmail())
        
        //Load all messages
        observeMessages()
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
                    let cM = MessageInfo(toID: mToID, fromID: mFromID, timeStamp: mTimeStamp, messageValue: mMessage)
                    self.messagesArray.append(cM)
                    self.tView.reloadData()
                }
            }, withCancel: nil)
        }, withCancel: nil)
        
    }
}
