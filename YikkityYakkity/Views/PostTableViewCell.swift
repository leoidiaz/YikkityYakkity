//
//  PostTableViewCell.swift
//  YikkityYakkity
//
//  Created by Cody on 4/11/19.
//  Copyright © 2019 Cody Adcock. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    //ONLY STORED LOCALLY!!!!
    var post: Post?
    
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var pointTotalLabel: UILabel!
    
    
    @IBAction func upvoteButtonTapped(_ sender: Any) {
        //ONLY UPDATES LOCALLY!!!!
        post?.score += 1
        pointTotalLabel.text = "\(post!.score)"

    }
    @IBAction func downvoteButtonTapped(_ sender: Any) {
        //ONLY UPDATES LOCALLY!!!!
        post?.score -= 1
        pointTotalLabel.text = "\(post!.score)"

    }
    
    //update with a function
    func updateView(with post: Post){
        self.post = post
        postTextLabel.text = "\"\(post.text)\"\n- \(post.author)"
        pointTotalLabel.text = "\(post.score)"
    }
}
