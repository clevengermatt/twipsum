//
//  PostDetailTableViewController.swift
//  Twipsum
//
//  Created by Matthew Clevenger on 09/06/2020.
//  Copyright © 2020 Matt Clevenger. All rights reserved.
//

import UIKit

/**
PostDetailTableViewController displays data for a Post and the Comment(s) which belong to it.
 */
class PostDetailTableViewController: UITableViewController {

    private var comments: [Comment] = []
    private var post: Post
    
    // An instance of APIClient.APIError representing
    // an error encountered in loading post comments
    private var apiError: APIClient.APIError?
    
    // A boolean representing whether or not the comments
    // are still attempting to be loaded
    private var isLoadingComments: Bool = true

    init(withPost post: Post, andStyle style: UITableView.Style = .plain) {
        self.post = post
        
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        
        title = "Comments"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .label
        
        tableView.backgroundColor = .secondarySystemBackground
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()
        tableView.register(CommentsHeaderView.self, forHeaderFooterViewReuseIdentifier: CommentsHeaderView.reuseIdentifier)
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.reuseIdentifier)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.reuseIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadComments()
    }
    
    // MARK: - Data handling
    
    /**
    Fetches comments data from the API the view controller's post.
     
     Should the comments fail to load, the view controller's apiError property is set
     to provide context to the tableview's comment section header text.
     Once tableview data is reloaded, due to a successful or failed request,
     the view controller's isLoadingComments propert is set to false to provide similar context.
     */
    private func loadComments() {
        
        comments = Cache.shared.comments.filter {
            $0.postId == post.id
        }
        
        if comments.count > 0 {
            isLoadingComments = false
            tableView.reloadData()
            return
        }
        
        APIClient.shared.fetchComments(forPostWithId: post.id) { (result) in
            switch result {
            case .success(let comments):
                // Update the comments cache
                Cache.shared.comments.append(contentsOf: comments)
                self.loadComments()
            case .failure(let error):
                self.apiError = error
                self.isLoadingComments = false
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return comments.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseIdentifier, for: indexPath) as? PostTableViewCell else {
                fatalError("Unable to dequeue UITableViewCell of type \(PostTableViewCell.reuseIdentifier))")
            }
            
            cell.configure(forPost: post)
            cell.userButton.addTarget(self, action: #selector(didTapUserButton), for: .touchUpInside)

            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.reuseIdentifier, for: indexPath) as? CommentTableViewCell else {
                fatalError("Unable to dequeue UITableViewCell of type \(CommentTableViewCell.reuseIdentifier))")
            }
            
            cell.configure(forComment: comments[indexPath.row])
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapEmailTextView))
            cell.emailTextView.addGestureRecognizer(tapGestureRecognizer)
            tapGestureRecognizer.name = comments[indexPath.row].email

            return cell
        default:
            fatalError("Exceeded expected number of sections")
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CommentsHeaderView.reuseIdentifier) as? CommentsHeaderView else {
                return nil
            }
            
            if !isLoadingComments {
                
                switch apiError {
                case .noData, .notFound, nil:
                    headerView.text = "\(comments.count) Comments"
                default:
                    headerView.text = "Data Unavailable"
                }
            }
            
            return headerView
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 44.0
        default:
            return .leastNormalMagnitude
        }
    }
    
    // MARK: - Button actions
    
    /**
    Navigates to an instance of PostsTableViewController
     with posts only from the selected user.
     */
    @objc private func didTapUserButton(_ sender: UIButton) {
        
        let posts = Cache.shared.posts.filter {
            $0.userId == post.userId
        }
        
        let postsTableViewController = PostsTableViewController(withPosts: posts)
        postsTableViewController.title = "User \(post.userId)"
        navigationController?.pushViewController(postsTableViewController, animated: true)
    }
    
    /**
    Fetches comments data from the API the view controller's post.
     
     Should the comments fail to load, the view controller's apiError property is set
     to provide context to the tableview's comment section header text.
     Once tableview data is reloaded, due to a successful or failed request,
     the view controller's isLoadingComments propert is set to false to provide similar context.
     */
    @objc private func didTapEmailTextView(_ gestureRecognizer: UIGestureRecognizer) {
        guard let email = gestureRecognizer.name else { return }
        
        if let url = URL(string: "mailto:\(String(describing: email))") {
          UIApplication.shared.open(url)
        }
    }
}
