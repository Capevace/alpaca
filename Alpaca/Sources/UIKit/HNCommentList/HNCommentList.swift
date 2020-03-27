//
//  HNCommentViewController.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 18.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

class HNCommentList: CommentsViewController {
    private let commentCellId = "commentCellId"
    
    var article: Item {
        didSet {
            currentlyDisplayed = CommentItem.from(self.article)
            self.tableView.reloadData()
        }
    }
    
    var textViewDelegate: HNCommentTextViewDelegate? = nil
    
    init(article: Item) {
        self.article = article
        super.init(style: .plain)
        
        self.makeExpandedCellsVisible = false
        self.fullyExpanded = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(HNCommentCell.self, forCellReuseIdentifier: commentCellId)
        currentlyDisplayed = CommentItem.from(self.article)
        
        tableView.backgroundColor = UIColor.commentsBackground
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let commentCell = tableView.dequeueReusableCell(withIdentifier: commentCellId, for: indexPath) as! HNCommentCell
        let comment = currentlyDisplayed[indexPath.row] as! CommentItem
        
        commentCell.textViewDelegate = textViewDelegate
        commentCell.level = comment.level ?? 0
        commentCell.content = comment.item.content
        commentCell.user = comment.item.user ?? "[deleted]"
        commentCell.timeAgo = comment.item.timeAgo
        
        return commentCell
    }
}
