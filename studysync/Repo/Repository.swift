//
//  Repository.swift
//  studysync
//
//  Created by Bishonath Lamichhane on 3/22/25.
//
import Foundation
import FirebaseFirestore
import FirebaseCore

class Repository {
    var db = Firestore.firestore();
    
    
    
    /// A method which finds all the registed universities in the application. This can be used to validate if a logged in user has a valid university or not
    /// - Returns: a list of universities registered
    func findAllUniversities(completion: @escaping ([University]) -> Void) {
        var universities = [University]();
        
        db.collection("universities").addSnapshotListener { snapshot, error in
            //we first unwrap the snapshot
            
            guard let snapshot = snapshot else{
                print(error!.localizedDescription)
                return
            }
            let university = snapshot.documents;
            universities = university.compactMap { document -> University? in
                
                //this data is a list of universities available in the firestore and it is in the dictionary format
                let data = document.data()
                return University(dictionary: data)
            }
            
//            for uni in universities {
//                print(uni.toString())
//            }
            completion(universities)
        }
        

        
    }
    
    func findUniversityNames(completion: @escaping ([String]) -> Void){
        var universitiesName: [String] = [String]()
        let universities = findAllUniversities { universities in
            guard !universities.isEmpty else{
                print("No universities found")
                return
            }
            for university in universities {
                universitiesName.append(university.universityName)
            }
            completion(universitiesName)
        }
}
    
    func addUniversity (university: University, completion: @escaping (Bool, Error?) -> Void){
        let universityRef = db.collection("universities").document(university.universityID)
        
        universityRef.setData(university.toDictionary()) { error in
            if let error = error {
                print("Error while adding the data to the firestore")
                completion(false, error)
                return
            }
            
            // at this point we know there is no errors in the code
            completion(true, nil)
        }
    }
    
    
    /// Adds the user to the database
    /// - Parameters:
    ///   - user: user object which is to be added in the database
    ///   - completion: returns whether the user has been added successfully or not
    func addUser (user:User, completion: @escaping (Bool, Error?) -> Void){
        let userRef = db.collection("users").document(user.email);
        
        userRef.setData(user.toDictionary()) { error in
            if let error = error {
                print("Error while adding user to the firestore")
                completion(false, error)
                return
            }
            
            //at this point we know user has been added to the database successfully
            completion(true, nil)
            
        }
    }
    
    func findUserByEmail(email:String, completion: @escaping(User?, Bool) -> Void){
        let documentRef = db.collection("users").document(email)
        
        documentRef.getDocument { snapshot, error in
            guard let snapshot = snapshot else{
                print("There was no snapshot found")
                completion(nil, false)
                return
            }
            let documentData = snapshot.data();
            
            if let documentData = documentData {
                let user = User(id: snapshot.documentID, dictionary: documentData)
                completion(user, true)
                return
            }
            else{
                return completion(nil, false)
            }
        }
            
        }
    
    
    func listAllPostsByUser(userID: String, completion: @escaping ([Post]?, Bool) -> Void) {
        var userPosts: [Post] = []
        
        let user = findUserByEmail(email: userID) { user, success in
            guard let user = user else{
                print("could not find the user with that userID/email")
                completion(nil, true)
                return
            }
            
            let userGroupRef = user.groups[0]
            let groupPostRef = userGroupRef.collection("posts")
            
            groupPostRef.getDocuments { snapshot, error in
                guard let snapshot = snapshot else{
                    print("Could nto find the documents in the collection of users")
                    completion(nil, true)
                    return
                }
                //there is posts in snapshot we need to get them now and store them in the list of posts
                
                let posts = snapshot.documents;
                
                userPosts = posts.compactMap({ document -> Post? in
                    let data = document.data()
                    return Post(dictionary: data)
                })
                completion(userPosts, false)
            }
            
            
        }
    }
    
    }
    



