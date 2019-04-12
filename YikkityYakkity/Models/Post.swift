//
//  Post.swift
//  YikkityYakkity
//
//  Created by Cody on 4/11/19.
//  Copyright © 2019 Cody Adcock. All rights reserved.
//

import Foundation
import CloudKit

class Post{
    //Mark: - Properties
    let text: String
    let author: String
    let timestamp: Date
    var score: Int
    
    let ckRecordID: CKRecord.ID
    
    //Mark: - Designated Initializer
    init(text: String, author: String, timestamp: Date = Date(), score: Int = 0, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)){
        self.text = text
        self.author = author
        self.timestamp = timestamp
        self.score = score
        self.ckRecordID = ckRecordID
    }
    
    //Create a Post from a CKRecord
    convenience init?(ckRecord: CKRecord){
        guard let text = ckRecord[Constants.TextKey] as? String,
            let author = ckRecord[Constants.AuthorKey] as? String,
            let timestamp = ckRecord[Constants.TimeStampKey] as? Date,
            let score = ckRecord[Constants.ScoreKey] as? Int else {return nil}
        
        self.init(text: text, author: author, timestamp: timestamp, score: score, ckRecordID: ckRecord.recordID)
    }
    
}

//Make a CKRecord from a post
extension CKRecord{
    convenience init(post: Post){
        //Create a record with the necessities (Record type and record ID
        self.init(recordType: Constants.PostRecordType, recordID: post.ckRecordID)
        //Add to that record
        self.setValue(post.text, forKey: Constants.TextKey)
        self.setValue(post.author, forKey: Constants.AuthorKey)
        self.setValue(post.timestamp, forKey: Constants.TimeStampKey)
        self.setValue(post.score, forKey: Constants.ScoreKey)
    }
}

//Constant Keys
struct Constants{
    static let PostRecordType = "Post"
    static let TextKey = "Text"
    static let AuthorKey = "Author"
    static let TimeStampKey = "Timestamp"
    static let ScoreKey = "ScoreKey"
}
