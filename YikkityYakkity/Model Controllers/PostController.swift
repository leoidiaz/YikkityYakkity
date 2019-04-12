//
//  PostController.swift
//  YikkityYakkity
//
//  Created by Cody on 4/11/19.
//  Copyright © 2019 Cody Adcock. All rights reserved.
//

import Foundation
import CloudKit

class PostController{
    
    //Shared Instance
    static let shared = PostController()
    private init(){}
    
    //Source of Truth
    var posts: [Post] = []
    
    //Reference to Database (A short hand way of referring to it.)
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //MARK: - Crud Functions
    //Create
    func createPost(text: String, author: String, completion: @escaping (Post?) -> Void){
        //Create a new post
        let newPost = Post(text: text, author: author)
        //Create a CKRecord from new post
        let newRecord = CKRecord(post: newPost)
        //Save that CKRecord to CloudKit
        publicDB.save(newRecord) { (record, error) in
            //Handle all errors
            if let error = error{
                print("🤬 There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 🤬")
                completion(nil)
                return
            }
            //unwrap record received
            guard let record = record else {return}
            //create post from record
            let post = Post(ckRecord: record)
            //Store it locally
            guard let unwrappedPost = post else {return}
            self.posts.append(unwrappedPost)
            //complete with pst
            completion(unwrappedPost)
        }
    }
    
    //Read
    func fetchAllPosts(completion: @escaping ([Post]?) -> Void){
        //Make predicate for query
        let predicate = NSPredicate(value: true)
        //Make query for perform
        let query = CKQuery(recordType: Constants.PostRecordType, predicate: predicate)
        //Make a fetch request
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            //handle error
            if let error = error{
                print("🤬 There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 🤬")
                completion(nil)
                return
            }
            //Unwrap records
            guard let records = records else {return}
            //Create an array of posts from the records
            let posts: [Post] = records.compactMap{Post(ckRecord: $0)}
            //Fill our source of truth
            self.posts = posts
            //done
            completion(posts)
        }
    }
    
    
}
