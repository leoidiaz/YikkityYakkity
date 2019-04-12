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
        PostController.shared.fetchAllPosts { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return PostController.shared.posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell
        
        let post = PostController.shared.posts[indexPath.row]
        cell?.updateView(with: post)
        
        return cell ?? UITableViewCell()
    }
    
    
    //MARK: = Bar Button Items
    @IBAction func createNewPostButtonTapped(_ sender: Any) {
        presentSimpleAlert(title: "Get Yikkity Yakkity!", message: "Content is user generated and shared with everyone, keep that in mind!")
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        PostController.shared.fetchAllPosts { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //Create an alert to enter in a message and author
    func presentSimpleAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //textField[0]
        alertController.addTextField { (textField) in
            textField.placeholder = "Put your message here! 🐃🐃🐃"
        }
        //textField[1]
        alertController.addTextField { (textField) in
            textField.placeholder = "Name: Preferably not your own! 😂"
        }
        //create cancel action
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //create post action
        let postAction = UIAlertAction(title: "Post", style: .default) { (_) in
            //unwrap values in text fields
            //check that they are not empty as well
            guard let bodyText = alertController.textFields?[0].text,
                let author = alertController.textFields?[1].text,
                !bodyText.isEmpty,
                !author.isEmpty else {return}
            //create a post from values in text fields
            PostController.shared.createPost(text: bodyText, author: author, completion: { (_) in
                DispatchQueue.main.async {
                    //after new post is made, reload the table view
                    self.tableView.reloadData()
                }
            })
        }
        //add actions to the alert controller
        alertController.addAction(dismissAction)
        alertController.addAction(postAction)
        //present alert controller
        self.present(alertController, animated: true)
    }
    
     // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // verify segue identifier
        if segue.identifier == "toDetailVC"{
            let destinationVC = segue.destination as? DetailViewController
            //create an index path to find a specific post
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            //select an individual post
            let post = PostController.shared.posts[indexPath.row]
            //update the detail view with the selected post
            destinationVC?.post = post
        }
     }
}
