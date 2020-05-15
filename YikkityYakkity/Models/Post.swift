//
//  Post.swift
//  YikkityYakkity
//
//  Created by Cody on 4/11/19.
//  Copyright © 2019 Cody Adcock. All rights reserved.
//

import Foundation
import CloudKit
//MARK: - Post Strings
struct PostStrings {
    static let recordTypeKey = "Post"
    static let textKey = "text"
    static let scoreKey = "score"
    static let authorKey = "author"
    static let timestampKey = "timestamp"
}
//MARK: - Post
class Post {
    var score: Int
    let text: String
    let author: String
    let timestamp: Date
    
    let recordID: CKRecord.ID
    
    init(score: Int = 0, text: String, author: String, timestamp: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)){
        self.score = score
        self.text = text
        self.author = author
        self.timestamp = timestamp
        self.recordID = recordID
    }
}
//MARK: - Convenience Init
extension Post {
    convenience init?(ckRecord: CKRecord) {
        guard let text = ckRecord[PostStrings.textKey] as? String,
            let score = ckRecord[PostStrings.scoreKey] as? Int,
            let author = ckRecord[PostStrings.authorKey] as? String,
            let timestamp = ckRecord[PostStrings.timestampKey] as? Date else { return nil }
        
        self.init(score: score, text: text, author: author, timestamp: timestamp, recordID: ckRecord.recordID)
    }
}
//MARK: - Equatable
extension Post: Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}
//MARK: - CkRecord Convenience Init
extension CKRecord {
    convenience init(post: Post) {
        self.init(recordType: PostStrings.recordTypeKey, recordID: post.recordID)
        setValuesForKeys([
            PostStrings.textKey : post.text,
            PostStrings.scoreKey : post.score,
            PostStrings.authorKey : post.author,
            PostStrings.timestampKey : post.timestamp
        ])
    }
}
