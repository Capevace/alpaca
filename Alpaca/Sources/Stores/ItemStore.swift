//
//  ItemStore.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 23.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

class ItemStore: ObservableObject {
    
    let feedItem: FeedItem
    
    @Published var itemState: DataLoadingState<Item> = .loading
    
    init(_ feedItem: FeedItem) {
        self.feedItem = feedItem
    }
    
    func fetchItem() {
        HackerNews.shared.getItem(self.feedItem.id) { (response) in
            self.itemState = self.itemState.from(response)
        }
    }
}
