//
//  PostTableViewController.swift
//  Twipsum
//
//  Created by Matthew Clevenger on 09/06/2020.
//  Copyright © 2020 Matt Clevenger. All rights reserved.
//

import UIKit

/**
PostsTableViewController displays data for given Posts.
 */
class PostsTableViewController: UITableViewController {
    
    private var posts: [Post] = []

    init(withPosts posts: [Post], andStyle style: UITableView.Style = .plain) {
        self.posts = posts
        
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .label
        
        tableView.backgroundColor = .secondarySystemBackground
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 10.0 + PostTableViewCell.userButtonHeight + 10.0, bottom: 0.0, right: 0.0)
        tableView.tableFooterView = UIView()
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.reuseIdentifier)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseIdentifier, for: indexPath) as? PostTableViewCell else {
            fatalError("Unable to dequeue UITableViewCell of type \(PostTableViewCell.reuseIdentifier))")
        }
        
        cell.userButton.tag = indexPath.row
        cell.configure(forPost: posts[indexPath.row])
        cell.userButton.addTarget(self, action: #selector(didTapUserButton), for: .touchUpInside)

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = posts[indexPath.row]
        
        let postDetailTableViewController = PostDetailTableViewController(withPost: post)
        navigationController?.pushViewController(postDetailTableViewController, animated: true)
    }
    
    // MARK: - Button actions
    
    /**
    Navigates to a new instance of PostsTableViewController
     with posts only from the selected user.
     */
    @objc private func didTapUserButton(_ sender: UIButton) {
        let userId = posts[sender.tag].userId
        
        // We should not navigate to an identical controller
        if title == "User \(userId)" { return }
        
        let posts = self.posts.filter {
            $0.userId == userId
        }
        
        let postsTableViewController = PostsTableViewController(withPosts: posts)
        postsTableViewController.title = "User \(userId)"
        navigationController?.pushViewController(postsTableViewController, animated: true)
    }
}
