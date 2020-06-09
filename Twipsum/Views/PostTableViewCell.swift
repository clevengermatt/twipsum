//
//  PostTableViewCell.swift
//  Twipsum
//
//  Created by Matthew Clevenger on 09/06/2020.
//  Copyright © 2020 Matt Clevenger. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    /**
    The reuse identifier for enqueueing dequeuing PostTableViewCells in a UITableView
     */
    static let reuseIdentifier: String = String(describing: PostTableViewCell.self)

    private let bodyTextView: UITextView = {
        let bodyTextView = UITextView()
        bodyTextView.font = .systemFont(ofSize: 13, weight: .regular)
        bodyTextView.isEditable = false
        bodyTextView.isScrollEnabled = false
        bodyTextView.isSelectable = false
        bodyTextView.isUserInteractionEnabled = false
        bodyTextView.textColor = .label
        bodyTextView.textContainer.lineFragmentPadding = 0
        bodyTextView.textContainerInset = UIEdgeInsets.zero
        return bodyTextView
    }()
    
    private let titleTextView: UITextView = {
        let titleTextView = UITextView()
        titleTextView.font = .systemFont(ofSize: 16, weight: .bold)
        titleTextView.isEditable = false
        titleTextView.isScrollEnabled = false
        titleTextView.isSelectable = false
        titleTextView.isUserInteractionEnabled = false
        titleTextView.textColor = .label
        titleTextView.textContainer.lineFragmentPadding = 0
        titleTextView.textContainerInset = UIEdgeInsets.zero
        return titleTextView
    }()
    
    let userButton: UIButton = {
        let userButton = UIButton()
        userButton.backgroundColor = .secondaryLabel
        userButton.setTitleColor(.systemBackground, for: .normal)
        userButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        userButton.clipsToBounds = true
        userButton.layer.cornerRadius = PostTableViewCell.userButtonHeight/2
        return userButton
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
    private let guidingLine: UIView = {
        let guidingLine = UIView()
        guidingLine.backgroundColor = .quaternaryLabel
        return guidingLine
    }()
    
    static let userButtonHeight: CGFloat = 44.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    Configures the PostTableViewCell with data for a given Post

     - Parameters:
        - post: The instance of Post for which the cell will be configured
     */
    func configure(forPost post: Post) {
        bodyTextView.text = post.body
        titleTextView.text = post.title
        userButton.setTitle(String(post.userId), for: .normal)
    }
    
    private func setupSubviews() {
        
        addSubview(userButton)
        addSubview(guidingLine)
        
        stackView.addArrangedSubview(titleTextView)
        stackView.addArrangedSubview(bodyTextView)
        addSubview(stackView)
        
        userButton.translatesAutoresizingMaskIntoConstraints = false
        userButton.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        userButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        userButton.heightAnchor.constraint(equalToConstant: PostTableViewCell.userButtonHeight).isActive = true
        userButton.widthAnchor.constraint(equalToConstant: PostTableViewCell.userButtonHeight).isActive = true
        
        guidingLine.translatesAutoresizingMaskIntoConstraints = false
        guidingLine.topAnchor.constraint(equalTo: userButton.bottomAnchor, constant: 10).isActive = true
        guidingLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        guidingLine.centerXAnchor.constraint(equalTo: userButton.centerXAnchor, constant: 0).isActive = true
        guidingLine.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        stackView.leadingAnchor.constraint(equalTo: userButton.trailingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
}
