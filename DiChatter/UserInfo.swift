//
//  UserInfo.swift
//  DiChatter
//
//  Created by Hardeep Singh on 12/15/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import Foundation


class UserInfo: NSObject, NSCoding {
    
    var id: String?
    var name: String?
    var email: String?
    var number: String?
    var gender: String?

    
    //defaut Constructor
    init(id: String, name: String, email: String, number: String, gender: String){
        self.id = id
        self.name = name
        self.email = email
        self.number = number
        self.gender =  gender
    }
    
    //for request/friend users
    init(id: String, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
        self.number = ""
        self.gender = ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.number, forKey: "number");
        aCoder.encode(self.gender, forKey: "gender");
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? String
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.email = aDecoder.decodeObject(forKey: "email") as? String
        self.number = aDecoder.decodeObject(forKey: "number") as? String
        self.gender = aDecoder.decodeObject(forKey: "gender") as? String
    }

    //Getters
    func getId() -> String {
        return self.id!
    }
    
    func getName() -> String {
        return self.name!
    }
    
    func getEmail() -> String {
        return self.email!
    }
    
    func getNumber() -> String {
        return self.number!
    }
    
    func getGender() -> String {
        return self.gender!
    }
    
    //Setters
    func setId(id: String){
        self.id = id
    }
    
    func setName(name: String){
        self.name = name
    }
    
    func setEmail(email: String){
        self.email = email
    }
    
    func setNumber(number: String){
        self.number = number
    }
    
    func setGender(gender: String){
        self.gender = gender
    }
}
