//
//  CommentsHeaderView.swift
//  Twipsum
//
//  Created by Matthew Clevenger on 09/06/2020.
//  Copyright © 2020 Matt Clevenger. All rights reserved.
//

import UIKit

class CommentsHeaderView: UITableViewHeaderFooterView {
    
    /**
    The reuse identifier for enqueueing dequeuing CommentsHeaderViews in a UITableView
     */
    static let reuseIdentifier: String = String(describing: CommentsHeaderView.self)

    public var text: String? {
        didSet {
            // When text has been set, animations should stop,
            // but if text is nil, animations shoul start
            guard text != nil else {
                activityIndicatorView.startAnimating()
                return
            }
            
            activityIndicatorView.stopAnimating()
            label.text = text
        }
    }
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupSubviews()
        
        tintColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        
        addSubview(activityIndicatorView)
        addSubview(label)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        activityIndicatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        activityIndicatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        activityIndicatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
    }
}
