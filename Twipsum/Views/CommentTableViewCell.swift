//
//  CommentTableViewCell.swift
//  Twipsum
//
//  Created by Matthew Clevenger on 09/06/2020.
//  Copyright © 2020 Matt Clevenger. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    /**
    The reuse identifier for enqueueing dequeuing CommentTableViewCells in a UITableView
     */
    static let reuseIdentifier: String = String(describing: CommentTableViewCell.self)

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
    
    let emailTextView: UITextView = {
        let emailTextView = UITextView()
        emailTextView.font = .systemFont(ofSize: 13, weight: .regular)
        emailTextView.isEditable = false
        emailTextView.isScrollEnabled = false
        emailTextView.textColor = .systemBlue
        emailTextView.textContainer.lineFragmentPadding = 0
        emailTextView.textContainerInset = UIEdgeInsets.zero
        return emailTextView
    }()
    
    private let nameTextView: UITextView = {
        let nameTextView = UITextView()
        nameTextView.font = .systemFont(ofSize: 15, weight: .semibold)
        nameTextView.isEditable = false
        nameTextView.isScrollEnabled = false
        nameTextView.isSelectable = false
        nameTextView.textColor = .label
        nameTextView.textContainer.lineFragmentPadding = 0
        nameTextView.textContainerInset = UIEdgeInsets.zero
        return nameTextView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    Configures the CommentTableViewCell with data for a given Comment

     - Parameters:
        - comment: The instance of Comment for which the cell will be configured
     */
    func configure(forComment comment: Comment) {
        bodyTextView.text = comment.body
        emailTextView.text = comment.email
        nameTextView.text = comment.name
    }
    
    private func setupSubviews() {
        
        stackView.addArrangedSubview(nameTextView)
        stackView.addArrangedSubview(emailTextView)
        stackView.addArrangedSubview(bodyTextView)
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
}
