//
//  chatDetailControllerViewController.swift
//  DiChatter
//
//  Created by Hardeep Singh on 12/26/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

class chatDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var name: String?
    
    @IBOutlet weak var tView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextView: UITextField!
    
    var ref: FIRDatabaseReference!
    
    var messagesArray = [MessageInfo]()
    var s = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //observe messages on server for update
        observeMessages()
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(printArray), userInfo: nil, repeats: false)
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
        
        print(m.getMessageValue())
        return cell
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        let sRef = ref.child("Messages")
        let cRef = sRef.childByAutoId()
        
        //create data variable
        let toID = "TestToID"
        let fromID = "TestFromID"
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        let messageValue = messageTextView.text!
        
        //set values
        cRef.updateChildValues(["toID": toID, "fromID": fromID, "timeStamp": timeStamp, "messageValue": messageValue])
        
        //reset the textField
        messageTextView.text = nil
        
        //make reference node for user to monitor messages
        //Give Index to current User
        ref.child("UserMessages").child(fromID).updateChildValues([cRef.key: 1])
        
        //Give Index to Recepient User
        ref.child("UserMessages").child(toID).updateChildValues([cRef.key: 1])
    }
    
    
    func observeMessages() {
        ref = FIRDatabase.database().reference()
        let currentID = "TestFromID"
        //query the UserMessage to find any new messages references
        self.ref.child("UserMessages").child(currentID).observe(.childAdded, with: { (snapshot) in
            let mID = snapshot.key
            //print(mID)
            self.observeMessageID(mID: mID)
        }, withCancel: nil)
    }
    
    func observeMessageID(mID: String) {
        //Query Messages to find the approriate message via reference Id (mID)
        self.ref.child("Messages").child(mID).observeSingleEvent(of: .value, with: { (snapshot) in
            //                let dictionary = snapshot.value as! NSDictionary
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let mToID = dictionary["toID"] as? String ?? ""
                let mFromID = dictionary["fromID"] as? String ?? ""
                let mTimeStamp = dictionary["timeStamp"] as? Int ?? 0
                let mMessage = dictionary["messageValue"] as? String ?? ""
               // print(mToID + ": " + mFromID + ": " + String(mTimeStamp) + ": " + mMessage)
                
                //add to array
                let cM = MessageInfo(toID: mToID, fromID: mFromID, timeStamp: mTimeStamp, messageValue: mMessage)
                self.messagesArray.append(cM)
            }
        }, withCancel: nil)
        
    }
    
    
    func printArray() {
        print("Array")
        for m in messagesArray {
            print(m.getMessageValue())
        }
        print(messagesArray.count)
    }
}
