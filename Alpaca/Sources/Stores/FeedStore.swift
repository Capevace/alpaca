//
//  FeedStore.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 18.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

///
class FeedStore: NSObject, ObservableObject {
    
    /// The current state of feed data.
    @Published var feedState: DataLoadingState<[FeedItem]> = .loading
    @Published var moreItemsState: DataLoadingState<[FeedItem]> = .success([])
    
    var loadedPage: Int = 0
    
    @Published var selectedCategory: Int = HackerNewsCategory.top.rawValue {
        didSet {
            loadedPage = 0
            fetchItems()
        }
    }
    
    var category: HackerNewsCategory {
        get {
            HackerNewsCategory(rawValue: selectedCategory)!
        }
        set {
            self.selectedCategory = newValue.rawValue
        }
    }
        
    /// The initializer is private because the static functions .fetched and .mocked should be used instead.
    private override init() {
        super.init()
    }
    
    /// Loads the HackerNews FeedItems (loads items on HN homepage).
    func fetchItems() {
        let currentCategory = category
        
        self.feedState = .loading
        
        HackerNews.shared.getFeed(category: currentCategory) { (response) in
            guard currentCategory == self.category else {
                // The user has switched tabs, we discard the results
                return
            }
            
            switch response {
            case .success(let feedItems):
                self.feedState = .success(feedItems)
            case .failure(let error):
                // TODO: Present error
                self.feedState = .failure(error.localizedDescription)
                print("Error getting [FeedItem]:", error.localizedDescription)
                break
            }
        }
    }
    
    func fetchNextPage() {
        let currentCategory = category
        self.loadedPage += 1
        self.moreItemsState = .loading
        
        HackerNews.shared.getFeed(category: currentCategory, page: self.loadedPage) { (response) in
            guard currentCategory == self.category else {
                // The user has switched tabs, we discard the results
                return
            }
            
            switch response {
            case .success(let newFeedItems):
                if case .success(let oldItems) = self.feedState {
                    let allItems = oldItems + newFeedItems
                    
                    self.moreItemsState = .success(newFeedItems)
                    self.feedState = .success(allItems)
                }
            case .failure(let error):
                // TODO: Present error
                self.moreItemsState = .failure(error.localizedDescription)
                print("Error getting [FeedItem]:", error.localizedDescription)
                break
            }
        }
    }
    
    /// Creates a HackerNewsStore instance and tells it to fetch data.
    static func fetched() -> FeedStore {
        let store = FeedStore()
        store.fetchItems()
        
        return store
    }
    
    /// Creates a mocked HackerNewsStore instance that pre-populates the store.
    static func mocked(_ feedState: DataLoadingState<[FeedItem]> = .success(FeedItem.mockedArray())) -> FeedStore {
        let store = FeedStore()
        store.feedState = feedState
        
        return store
    }
}
