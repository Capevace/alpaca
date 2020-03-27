//
//  CommentView.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 05.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI
import Atributika

struct CommentList: UIViewControllerRepresentable {
    
    var article: Item
    var onLinkTap: (DetectionType) -> Void = { _ in return }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CommentList>) -> HNCommentList {
        let vc =  HNCommentList(article: self.article)
        vc.delegate = context.coordinator
        vc.textViewDelegate = context.coordinator
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: HNCommentList, context: UIViewControllerRepresentableContext<CommentList>) {
        uiViewController.article = self.article
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CommentsViewDelegate, HNCommentTextViewDelegate {
        func onLinkTap(_ type: DetectionType) {
            parent.onLinkTap(type)
        }
        
        func commentCellExpanded(atIndex index: Int) {
            
        }
        
        func commentCellFolded(atIndex index: Int) {
            
        }
        
        var parent: CommentList
        
        init(_ parent: CommentList) {
            self.parent = parent
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentList(article: Item.mocked())
    }
}
