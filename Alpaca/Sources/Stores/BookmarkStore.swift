//
//  BookmarkStore.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 19.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

class BookmarkStore: NSObject, ObservableObject {

    var feedItem: FeedItem
    
    @Published var isBookmarked: Bool = false
    
    let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    
    init(_ feedItem: FeedItem) {
        self.feedItem = feedItem
        self.isBookmarked = HackerNews.shared.bookmarks.isBookmarked(feedItem.id)
    }
    
    func toggleBookmark() {
        self.isBookmarked = HackerNews.shared.bookmarks.toggleBookmark(self.feedItem.id)
        
        HackerNews.shared.cache.cache(self.feedItem, permanent: self.isBookmarked)

        self.selectionFeedbackGenerator.selectionChanged()
    }
}

