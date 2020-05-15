//
//  DetailViewController.swift
//  YikkityYakkity
//
//  Created by Cody on 4/11/19.
//  Copyright © 2019 Cody Adcock. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var postTextLabel: UILabel!
    //MARK: - Properties
    var post: Post?{
        didSet{
            updateViews()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateViews(){
        loadViewIfNeeded()
        guard let post = post else { return }
        postTextLabel.text = "\(post.text) \n \n ~ \(post.author)"
    }

}
