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
        let universities: () = findAllUniversities { universities in
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
        
        let user: () = findUserByEmail(email: userID) { user, success in
            guard let user = user else{
                print("could not find the user with that userID/email")
                completion(nil, true)
                return
            }
            
            let userGroupRef = user.groups[0]
            let groupPostRef = userGroupRef.collection("posts")
            
            groupPostRef
                .order(by: "postedTime", descending: true)
                .addSnapshotListener { snapshot, error in
                    guard let snapshot = snapshot else{
                        print("Could not find the documents in the collection of users")
                        completion(nil, true)
                        return
                    }
                    //there is posts in snapshot we need to get them now and store them in the list of posts
                    
                    let posts = snapshot.documents;
                    userPosts = posts.compactMap({ document -> Post? in
                        let data = document.data()
                        return Post(postID: document.documentID , dictionary: data)
                    })
                    completion(userPosts, false)
                }
            
            
        }
    }
    
    func getUserUniversityByReference(universityReference: DocumentReference, completion: @escaping (University?, Bool) -> Void){
        let uniRef = db.document(universityReference.path)
        
        uniRef.getDocument { snapshot, error in
            if error != nil {
                completion(nil, true)
                return
            }
            
            let data = snapshot?.data();
            //this data of university is in dictionary format so we need to convert it into the university class
            
            guard let data = data else{
                completion(nil, true)
                return
            }
            let university = University(dictionary: data);
            completion(university, false)
            
        }
    }
    
    func listAllCommentsByPost(postID:String, completion: @escaping([Comment]?, Bool) -> Void){
        
        var comments = [Comment]()
        let postRef = db.collection("universities").document("AIT").collection("groups").document("swift").collection("posts").document(postID).collection("comments")
        
        postRef
            .order(by: "commentTime", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else{
                    return completion(nil, true)
                }
                
                let commentDictionaryArray = snapshot.documents
                
                comments = commentDictionaryArray.compactMap { document -> Comment? in
                    let comment = document.data()
                    return Comment(commentID:document.documentID , dictionary: comment)
                }
                completion(comments, false)
            }
        
        
        
    }
    
    func createNewPostByUser(user:User, post:Post, completion: @escaping (Bool, Error?) -> Void){
        let postRef = user.university.collection("groups").document("swift").collection("posts");
        
        postRef.addDocument(data: post.toDictionary()) { error in
            guard error == nil else{
                completion(false, error)
                return
            }
            
            completion(true, nil)
        }
    }
    
    func addNewCommentInAPost(user:User, postID:String, comment:Comment, completion: @escaping(Bool, Error?) -> Void){
        let commentRef = user.university.collection("groups").document("swift").collection("posts").document(postID).collection("comments")
        
        commentRef.addDocument(data: comment.toDictionary()) { error in
            guard error == nil else{
                print("Comment could not be added to the database \(String(describing: error))")
                completion(false, error)
                return
            }
            
            //at this point we know the comment has been added successfully
            
            completion(true, nil)
        }
    }
    
    func getLikesInAPost(postID:String, userRef: DocumentReference, completion: @escaping([String]?, Error?) -> Void ){
        var likesEmailList = [String]();
        let likesRef = userRef.collection("groups").document("swift").collection("posts").document(postID).collection("likes");
        
        likesRef.addSnapshotListener { snapshot, error in
            guard error == nil else{
                completion(nil, error)
                return
            }
            
            guard let snapshot = snapshot else{
                print("no snapshot found in the document")
                completion(nil, nil)
                return
            }
            
            let likes = snapshot.documents;
            if likes.count > 0 {
                likesEmailList = likes.compactMap({ like -> String? in
                    let data =  like.data();
                    
                    return data["likedBy"] as? String
                })
                
                completion(likesEmailList, nil)
            }
            else{
                return completion (nil, nil)
            }

        }
    }
    
    func getCommentsInAPost(postID:String, userRef: DocumentReference, completion: @escaping(Int?, Error?) -> Void ){
        let likesRef = userRef.collection("groups").document("swift").collection("posts").document(postID).collection("comments");
        
        likesRef.addSnapshotListener { snapshot, error in
            guard error == nil else{
                completion(nil, error)
                return
            }
            
            guard let snapshot = snapshot else{
                print("no likes found in the document")
                completion(nil, nil)
                return
            }
            
            let likes = snapshot.documents;
            
            
            completion(likes.count, nil)
        }
    }
    
    func toggleLikeInAPost(postID:String, userRef:DocumentReference, userID:String, completion: @escaping(Bool, String,  Error?) -> Void ) {
        let likeRef = userRef.collection("groups").document("swift").collection("posts").document(postID).collection("likes").document(userID)
        
        likeRef.getDocument { snapshot, error in
            guard error == nil else{
                completion(false,"", error)
                return
            }
            
            if let snapshot = snapshot, snapshot.exists{
                likeRef.delete { error in
                    if let error = error {
                        completion(false,"", error)
                    } else {
                        completion(true, "removed", nil)
                    }
                }
            }
            else{
                likeRef.setData(
                    ["likedBy" : "\(userID)"]) { error in
                        if error != nil {
                            completion(false,"", error)
                                return
                        }
                        completion(true, "added", nil)
                    }
            }
            

        }
    }
    
    func deletePost(postID:String, userRef:DocumentReference, completion: @escaping(Bool, Error?) -> Void ){
        let postRef = userRef.collection("groups").document("swift").collection("posts").document(postID)
            
            
            postRef.delete { error in
                guard error == nil else{
                    completion(false, error)
                    return
                }
                //deletion is successful
                completion(true, nil);
            }
    }
    
    func hasUserLikedThePost(postID:String, userRef:DocumentReference, userID:String, completion: @escaping(Bool, Error?) -> Void ) {
        let likeRef = userRef.collection("groups").document("swift").collection("posts").document(postID).collection("likes").document(userID)
        
        likeRef.addSnapshotListener { snapshot, error in
            guard error == nil else{
                completion(false, error)
                return 
            }
            
            if let snapshot = snapshot {
                if snapshot.exists{
                    completion(true, nil)
                }
                else{
                    completion(false, nil)
                }
            }
        }
    }
    
    func getTotalLikesInAComment (postID:String, commentID:String, userRef: DocumentReference, completion: @escaping(Int?, Error?) -> Void ){
        let commentLikeRef = userRef.collection("groups").document("swift").collection("posts").document(postID).collection("comments").document(commentID).collection("likes")
        
        commentLikeRef.addSnapshotListener { snapshot, error in
            guard error == nil else{
                print("Firestore error")
                completion(nil, error)
                return
            }
            
            // no errors found, we need to check the snapshot now
            guard let snapshot = snapshot else{
                print("no likes yet i think")
                completion(0, nil)
                return
            }
            //at this point there is some data in the database
            let likesCount = snapshot.documents.count
            completion(likesCount, nil)
            
        }
    }
    
    func toggleLikeInAComment(postID:String, commentID:String, currentUser: User, completion: @escaping(Bool, Error?) -> Void ){
        let commentLikeRef = currentUser.university.collection("groups").document("swift").collection("posts").document(postID).collection("comments").document(commentID).collection("likes").document(currentUser.email)
        
        commentLikeRef.getDocument { snapshot, error in
            guard error == nil else{
                completion(false, error)
                return
            }
            
            if let snapshot = snapshot, snapshot.exists {
                //there is a data already delete it
                commentLikeRef.delete { error in
                    if let error = error {
                        completion(false, error)
                    } else {
                        completion(true, nil)
                    }
                }

            }
            else{
                //there is no data, set it now
                commentLikeRef.setData(["LikerEmail" : currentUser.email]) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                        completion(false, error)
                    } else {
                        print("Document successfully added!")
                        completion(true, nil)
                    }
                }
            }
        }
            
         
        
        
        
        
        
        
        
        }
    
    func hasUserLikedTheComment(postID:String, commentID:String, currentUser: User, completion: @escaping(Bool, Error?) -> Void ){
        let commentLikeRef = currentUser.university.collection("groups").document("swift").collection("posts").document(postID).collection("comments").document(commentID).collection("likes").document(currentUser.email)
        
        commentLikeRef.addSnapshotListener { snapshot, error in
            guard error == nil else{
                completion(false, error)
                return
            }
            
            if let snapshot = snapshot {
                if snapshot.exists{
                    completion(true, nil)
                }
                else{
                    completion(false, nil)
                }
            }
        }
    }
}
    



