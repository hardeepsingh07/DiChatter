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

class MessageInfo: NSObject {
    
    var toID: String?
    var fromID: String?
    var timeStamp: Int?
    var messageValue: String?
    
    init(toID: String, fromID: String, timeStamp: Int, messageValue: String) {
        self.toID = toID 
        self.fromID = fromID 
        self.timeStamp = timeStamp 
        self.messageValue = messageValue
    }
    
    func chatPartnerId() -> String? {
        return fromID == FIRAuth.auth()?.currentUser?.uid ? toID : fromID
    }
}
