//
//  Messages.swift
//  DiChatter
//
//  Created by Hardeep Singh on 12/28/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class MessageInfo {
    
    var toID: String?
    var fromID: String?
    var timeStamp: Int?
    var messageValue: String?
    
//    func chatPartnerId() -> String? {
//        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
//    }
    
    init(toID: String, fromID: String, timeStamp: Int, messageValue: String) {
        self.toID = toID 
        self.fromID = fromID 
        self.timeStamp = timeStamp 
        self.messageValue = messageValue
    }
    
    func getToID() -> String{
        return self.toID!
    }
    
    func getFromID() -> String {
        return self.fromID!
    }
    
    func getTimeStamp() -> Int {
        return self.timeStamp!
    }
    
    func getMessageValue() -> String {
        return self.messageValue!
    }
}
