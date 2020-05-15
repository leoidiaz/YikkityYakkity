//
//  PostTableViewCell.swift
//  YikkityYakkity
//
//  Created by Cody on 4/11/19.
//  Copyright © 2019 Cody Adcock. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var pointTotalLabel: UILabel!
    
    //MARK: - Properties
    var post: Post?{
        didSet{
            updateCell()
        }
    }
    @IBAction func upvoteButtonTapped(_ sender: Any) {
        guard let post = post else { return }
        post.score += 1
        PostController.shared.updatePost(post: post) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedPost):
                    self.pointTotalLabel.text = "\(updatedPost.score)"
                case .failure(let error):
                    print(error.errorDescription)
                }
            }
        }
    }
    @IBAction func downvoteButtonTapped(_ sender: Any) {
        guard let post = post else { return }
        post.score -= 1
        PostController.shared.updatePost(post: post) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedPost):
                    self.pointTotalLabel.text = "\(updatedPost.score)"
                case .failure(let error):
                    print(error.errorDescription)
                }
            }
        }
    }
    
    func updateCell(){
        guard let post = post else { return }
        postTextLabel.text = "\(post.text) \n ~ \(post.author)"
        pointTotalLabel.text = "\(post.score)"
    }
    
}
