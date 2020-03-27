//
//  ArticleViewStore.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 18.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI
import WebView

class ArticleStore: ObservableObject {
 
    let feedItem: FeedItem
    
    @Published var itemStore: ItemStore
    @Published var sheetStore: CommentSheetStore
    @Published var bookmarkStore: BookmarkStore
    @Published var safariStore: SafariStore
    
    @Binding var isDisplayed: Bool
    
    init(_ feedItem: FeedItem, isDisplayed: Binding<Bool>) {
        self.feedItem = feedItem
        self.itemStore = ItemStore(feedItem)
        self.sheetStore = CommentSheetStore()
        self.bookmarkStore = BookmarkStore(feedItem)
        self.safariStore = SafariStore(feedItem.safeUrl, articleViewDisplayed: isDisplayed)
        
        self._isDisplayed = isDisplayed
    }
    
    func setup() {
        self.itemStore.fetchItem()
        self.safariStore.enable()
    }
    
    let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    
    func openShareSheet() {
        NotificationCenter.default.post(Notification(name: .shouldOpenShareSheet, object: nil, userInfo: ["url": self.feedItem.safeUrl]))
    }
    
    func dismissArticleView() {
        self.isDisplayed = false
    }
    
    static func mocked() -> ArticleStore {
        let store = ArticleStore(FeedItem.mocked(), isDisplayed: .constant(true))
        store.itemStore.itemState = .success(Item.mocked())
        
        return store
    }
}
