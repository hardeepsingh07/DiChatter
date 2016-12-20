//
//  UserInfo.swift
//  DiChatter
//
//  Created by Hardeep Singh on 12/15/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import Foundation


public class UserInfo{
    
    var id: String
    var name: String
    var email: String
    var number: String
    var gender: String
    var friendList = [String]();
    var requestList = [String]();

    
    //defaut Constructor
    public init(){
        self.id = ""
        self.name = ""
        self.email = ""
        self.number = ""
        self.gender =  ""
        self.friendList = []
        self.requestList = []
    }
    
    //for self User
    func defaultUser(id: String, name: String, email: String, number: String, gender: String, friendList: [String], requestList: [String]) {
        self.id = id
        self.name = name
        self.email = email
        self.number = number
        self.gender =  gender
        self.friendList = friendList
        self.requestList = requestList
    }
    
    //for request/friends users
    func customUser(id: String, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
        
    }
    
    //Getters
    func getId() -> String {
        return self.id
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getEmail() -> String {
        return self.email
    }
    
    func getNumber() -> String {
        return self.number
    }
    
    func getGender() -> String {
        return self.gender
    }
    
    func getFriendList() -> [String] {
        return self.friendList
    }
    
    func getRequestList() -> [String] {
        return self.requestList
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
    
    func setFriendList(friendList: [String]) {
        self.friendList = friendList
    }
    
    func setRequestList(requestList: [String]) {
        self.requestList = requestList
    }
}
