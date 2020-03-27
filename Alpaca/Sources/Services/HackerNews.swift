//
//  HackerNews.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 04.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import UIKit
import Alamofire

class HackerNews {
    
    static var shared: HackerNews = HackerNews()
    
    let api = HackerNewsAPI()
    let cache = HackerNewsCache()
    let bookmarks = HackerNewsBookmarks()
    
    // Disable initializer, we're only using the shared instance for now.
    private init() {
        
    }
    
    func getFeed(category: HackerNewsCategory = .top, page: Int = 0, _ handler: @escaping (Result<[FeedItem], Error>) -> Void) {
        if category == .bookmarked {
            let ids = bookmarks.items()
            let items = cache.feed(ids)
            
            handler(.success(items))
        } else {
            api.getFeed(category, page, handler)
        }
    }
    
    func getItem(_ id: Int, handler: @escaping (Result<Item, Error>) -> Void) {
        api.getItem(id) { (result) in
            if let item = try? result.get() {
                self.cache.updateCache(with: item)
            }
            
            handler(result)
        }
    }
}
