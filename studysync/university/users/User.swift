//
//  User.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 3/22/25.
//
import Foundation
import FirebaseFirestore

class User {
    var userID: String!
    var name: String
    var email: String
    var role:String
    var university: DocumentReference
	var groups : [DocumentReference]
    
    //default initialiser called when we create a user. ID will be created by firestore
    init(name: String, email: String, role:String,  university: DocumentReference, groups: [DocumentReference]) {
        self.name = name
        self.email = email
        self.university = university
        self.groups = groups
        self.role = role
    }
    
    //This initialiser is used when we query the database
    convenience init(id: String, name: String, email: String, role:String, university: DocumentReference, groups: [DocumentReference]) {
        self.init(name: name,
                  email: email,
                  role:role,
                  university: university,
                  groups: groups)
        self.userID = id
    }
    
    //this will be used whenever we want to fetch the user from the database by providing id and the rest will be empty
    convenience init ?(id:String) {
            self.init(name: "",
                      email: "",
                      role:"",
                      university: Firestore.firestore().collection("users").document("test 1"),
                      groups: [DocumentReference]()
																)
    }
    
				
				//This will be used when we get a user dictionary from the firestore and we want that in the User class format
    convenience init(id: String, dictionary: [String:Any]) {
        self.init(id: id,
                  name: dictionary["name"] as? String ?? "",
                  email: dictionary["email"] as? String ?? "",
                  role:dictionary["role"] as? String ?? "",
                  university: dictionary["university"] as? DocumentReference ?? Firestore.firestore().collection("users").document("test 1"),
                  groups: dictionary["groups"] as? [DocumentReference] ?? [DocumentReference]()
												)
    }
				
				//The following method will be used when we want to write a user dictionary in the firestore so that we convert the user into dictionary
				func toDictionary() -> [String: Any] {
								var userDictionary: [String : Any] = [:]
								userDictionary["id"] = self.userID
								userDictionary["name"] = self.name
								userDictionary["email"] = self.email
                                userDictionary["role"] = self.role
								userDictionary["university"] = self.university
								userDictionary["groups"] = self.groups
								
								return userDictionary
				}
				
				
				
				
}
