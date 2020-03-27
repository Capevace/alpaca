//
//  HNCommentCell.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 18.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI
import Atributika

class HNCommentCell: CommentCell {
    
    var commentTextView: HNCommentTextView {
        get {
            return self.commentViewContent as! HNCommentTextView
        }
    }
    
    open var textViewDelegate: HNCommentTextViewDelegate? {
        get {
            return self.commentTextView.delegate
        } set(value) {
            self.commentTextView.delegate = value
        }
    }
    
    open var content: String = "" {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacing = 15
            
            let all = Style
                .font(.systemFont(ofSize: 14))
                .foregroundColor(.commentTextColor)
                .paragraphStyle(paragraphStyle)
//
//
//
//            let p = Style("p")
            
            let links = Style
                .foregroundColor(.accentColor, .normal)
                .foregroundColor(.brown, .highlighted)
            
            let b = Style("b").font(.boldSystemFont(ofSize: 14))
            let u = Style("u").underlineStyle(.single)
            
            let styledContent = content
                .style(tags: u, b)
                .styleAll(all)
                .styleLinks(links)
                
            (self.commentViewContent as! HNCommentTextView).contentLabel.attributedText = styledContent
        }
    }
    
    open var user: String {
        get {
            return self.commentTextView.userLabel.text ?? ""
        } set(value) {
            self.commentTextView.userLabel.text = value
        }
    }
    
    open var timeAgo: String {
        get {
            return self.commentTextView.timeAgoLabel.text ?? ""
        } set(value) {
            self.commentTextView.timeAgoLabel.text = value
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commentViewContent = HNCommentTextView()
        
        let background = UIColor.commentsBackground
//        background = UIColor.systemBackground
        
        self.rootCommentMarginColor = background
        self.rootCommentMargin = 10
        self.commentMarginColor = background
        self.commentMargin = 5
        self.indentationColor = background
        self.indentationIndicatorColor = UIColor.commentTextColor.withAlphaComponent(0.3)
        self.indentationIndicatorThickness = 2
        self.indentationUnit = 20
        
        self.commentViewContent?.backgroundColor = background
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
