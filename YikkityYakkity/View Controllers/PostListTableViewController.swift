//
//  PostListTableViewController.swift
//  YikkityYakkity
//
//  Created by Cody on 4/11/19.
//  Copyright © 2019 Cody Adcock. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostController.shared.posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else {return UITableViewCell()}
        
        let post = PostController.shared.posts[indexPath.row]
        cell.post = post
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let postToDelete = PostController.shared.posts[indexPath.row]
            guard let index = PostController.shared.posts.firstIndex(of: postToDelete) else { return }
            PostController.shared.deletePost(post: postToDelete) { (result) in
                switch result {
                case .success(_):
                    PostController.shared.posts.remove(at: index)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                case .failure(let error):
                    print(error)
                    print(error.errorDescription)
                }
            }
        }
    }
    
    //MARK: = Bar Button Items
    @IBAction func createNewPostButtonTapped(_ sender: Any) {
        presentAlertController(title: "Get Yikkity Yakkity", message: "Share your post")
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        fetchPosts()
    }
    
    //MARK: - Helper Methods
    func fetchPosts(){
        PostController.shared.fetchPosts { (result) in
            DispatchQueue.main.async {
                switch result{
                case .success(_):
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                    print(error.errorDescription)
                }
            }
        }
    }
    
    func presentAlertController(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Put your message here! 🐏🐏🐏"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter author name -- hopefully not you..."
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let postAction = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let bodyText = alertController.textFields?[0].text, !bodyText.isEmpty, let author = alertController.textFields?[1].text, !author.isEmpty else { return }
            PostController.shared.createPost(text: bodyText, author: author) { [weak self] (result) in
                switch result{
                case .success(_):
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.errorDescription)
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(postAction)
        present(alertController, animated: true)
        
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow, let destinationVC = segue.destination as? DetailViewController else { return }
            let post = PostController.shared.posts[indexPath.row]
            destinationVC.post = post
        }
    }
    
}
