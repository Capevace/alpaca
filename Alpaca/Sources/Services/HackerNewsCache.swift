//
//  HNCache.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 19.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import Foundation

class HackerNewsCache {

    private static let cacheIndexKey = "cacheIdIndex"
    private static let cachedItemKeyPrefix = "cachedItem_"
    
    var cacheIndex: [Int: Date?] {
        UserDefaults.standard.structData(CacheIndex.self, forKey: HackerNewsCache.cacheIndexKey)?.cached ?? [:]
    }
    
    init() {
        // On start, check for and delete all expired cache items
        self.deleteExpiredItems()
    }

    private func keyForItem(_ id: Int) -> String {
        return "\(HackerNewsCache.cachedItemKeyPrefix)\(id)"
    }

    func cache(_ item: FeedItem, permanent: Bool = false) {
        UserDefaults.standard.setStruct(item, forKey: self.keyForItem(item.id))
        self.addIdToCacheIndex(item.id, permanent: permanent)
    }
    
    func updateCache(with item: Item) {
        if self.cacheIndex[item.id] != nil {
            UserDefaults.standard.setStruct(item.feedItem(), forKey: self.keyForItem(item.id))
        }
    }

    func item(_ id: Int) -> FeedItem? {
        return UserDefaults.standard.structData(FeedItem.self, forKey: self.keyForItem(id))
    }
    
    func feed(_ ids: [Int]) -> [FeedItem] {
        var feed: [FeedItem] = []
        
        for id in ids {
            if let item = self.item(id) {
                feed.append(item)
            }
        }
        
        return feed
    }
    
    private func addIdToCacheIndex(_ id: Int, permanent: Bool = false) {
        var cachedIds = cacheIndex

        cachedIds[id] = permanent
            ? nil
            : Date().addingTimeInterval(60 * 30)

        UserDefaults.standard.setStruct(CacheIndex(cached: cachedIds), forKey: HackerNewsCache.cacheIndexKey)
    }
    
    private func deleteExpiredItems() {
        var ids = cacheIndex
        
        for (id, expiresAt) in ids {
            guard let expiresAt = expiresAt else {
                continue
            }
            
            // if expiresAt has passed, remove
            if expiresAt < Date() {
                // Remove from cache index
                ids.removeValue(forKey: id)
                
                UserDefaults.standard.removeObject(forKey: self.keyForItem(id))
            }
        }
        
        UserDefaults.standard.setStruct(CacheIndex(cached: ids), forKey: HackerNewsCache.cacheIndexKey)
    }
    
    struct CacheIndex: Codable {
        let cached: [Int: Date?]
    }
}
