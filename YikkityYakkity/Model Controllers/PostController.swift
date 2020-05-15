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
    func createPost(text: String, author: String, completion: @escaping (Result <Bool, PostError>) -> Void){
        
    }
    // Read
    
    // Update
    
    // Delete
}
