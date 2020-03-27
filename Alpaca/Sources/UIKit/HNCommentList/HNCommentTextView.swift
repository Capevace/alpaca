//
//  HNCommentTextView.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 18.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI
import Atributika

class HNCommentTextView: UIView {
    
    var delegate: HNCommentTextViewDelegate? = nil
    
    var contentLabel: AttributedLabel = {
        let lbl = AttributedLabel()
        lbl.attributedText = "".styleAll(Style())
        lbl.textColor = UIColor.label
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        return lbl
    }()
    
    var userLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "annonymous"
        lbl.textColor = UIColor.secondaryLabel
        lbl.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
        lbl.textAlignment = .left
        return lbl
    }()
    
    var timeAgoLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "now"
        lbl.textColor = UIColor.secondaryLabel
        lbl.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        lbl.textAlignment = .left
        return lbl
    }()
    
    var controlView: UIView = {
        let v = UIView()
        let actionBtn = UIButton(type: UIButton.ButtonType.infoDark)
        actionBtn.setTitle("Like", for: .normal)
        
//        v.addSubview(actionBtn)
//
//        actionBtn.translatesAutoresizingMaskIntoConstraints = false
//
//        actionBtn.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -10).isActive = true
//        actionBtn.bottomAnchor.constraint(equalTo: v.bottomAnchor).isActive = true
//        actionBtn.topAnchor.constraint(equalTo: v.topAnchor).isActive = true
//        actionBtn.leadingAnchor.constraint(equalTo: v.leadingAnchor).isActive = true
        
        return v
    }()
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        let margin = CGPoint(x: 20, y: 10)
        
        addSubview(userLabel)
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        userLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin.x).isActive = true
        userLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin.y).isActive = true
        
        addSubview(timeAgoLabel)
        timeAgoLabel.translatesAutoresizingMaskIntoConstraints = false
        timeAgoLabel.leadingAnchor.constraint(equalTo: userLabel.trailingAnchor, constant: 8).isActive = true
        timeAgoLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin.y).isActive = true
        
        addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin.x).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin.x).isActive = true
        contentLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 5).isActive = true
        contentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin.y).isActive = true
        
        
        addSubview(controlView)
        controlView.translatesAutoresizingMaskIntoConstraints = false
        controlView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin.x).isActive = true
        controlView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor).isActive = true
        controlView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        contentLabel.onClick = self.onClick
    }
    
    func onClick(_ label: AttributedLabel, _ detection: Detection) {
        self.delegate?.onLinkTap(detection.type)
    }
}

protocol HNCommentTextViewDelegate {
    func onLinkTap(_ type: DetectionType)
}
