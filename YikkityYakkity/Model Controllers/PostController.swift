//
//  PostController.swift
//  YikkityYakkity
//
//  Created by Cody on 4/11/19.
//  Copyright © 2019 Cody Adcock. All rights reserved.
//

import Foundation
import CloudKit

class PostController {

    static let shared = PostController()
    
    var posts = [Post]()
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //MARK: - CRUD Methods
    
    // Create
    func createPost(text: String, author: String, completion: @escaping (Result <Bool, YikkityError>) -> Void){
        let newPost = Post(text: text, author: author)
        let newRecord = CKRecord(post: newPost)
        publicDB.save(newRecord) { (record, error) in
            
            if let error = error{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = record, let savedPost = Post(ckRecord: record) else { return completion(.failure(.couldNotUnwrap))}
            self.posts.append(savedPost)
            completion(.success(true))
        }
    }
    // Read
    
    func fetchPosts(completion: @escaping(Result<Bool, YikkityError>) -> Void){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: PostStrings.recordTypeKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let records = records else { return completion(.failure(.couldNotUnwrap))}
            print("Fetched All Posts")
            let posts: [Post] = records.compactMap({Post(ckRecord: $0)})
            self.posts = posts
            completion(.success(true))
        }
    }
    
    // Update
    
    func updatePost(post: Post, completion: @escaping(Result<Post, YikkityError>) -> Void){
        let recordToUpdate = CKRecord(post: post)
        let operation = CKModifyRecordsOperation(recordsToSave: [recordToUpdate])
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.ckError(error)))
            }
            guard let record = records?.first, let updatedPost = Post(ckRecord: record) else { return completion(.failure(.couldNotUnwrap))}
            print("Updated \(updatedPost.recordID)Successfully in cloud kit")
            completion(.success(updatedPost))
        }
        publicDB.add(operation)
    }
    
    // Delete
    
    func deletePost(post: Post, completion: @escaping(Result<Bool, YikkityError>) -> Void){
        let operation = CKModifyRecordsOperation(recordIDsToDelete: [post.recordID])
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (_, recordIDs, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.ckError(error)))
            }
            guard let recordIDs = recordIDs else { return completion(.failure(.unableLocateDeletedIDs))}
             print("That post with :\(recordIDs) is swimming with the fishes boss")
            completion(.success(true))
//            if records?.count == 0 {
//                print("That post is swimming with the fishes boss")
//                completion(.success(true))
//            } else {
//                return completion(.failure(.unexpectedRecordsFound))
//            }
        }
        publicDB.add(operation)
    }
}
