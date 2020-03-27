//
//  BookmarkService.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 19.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import Foundation

class HackerNewsBookmarks {

    private static let bookmarkedItemsKey = "bookmarkedItems"
    private static let itemsPerPage = 50
    
    var bookmarked: [Int: Bookmark]
    
    init() {
        self.bookmarked = UserDefaults.standard.structData(BookmarkIndex.self, forKey: HackerNewsBookmarks.bookmarkedItemsKey)?.bookmarked ?? [:]
    }
    
    func items(_ page: Int = 0) -> [Int] {
        let feeds = bookmarked
            .sorted(by: { (first, second) -> Bool in
                first.value.bookmarkedAt < second.value.bookmarkedAt
            })
            .map { $0.key }
            .chunked(into: HackerNewsBookmarks.itemsPerPage)
        print(feeds)
        if page < feeds.count {
            return feeds[page]
        }
        
        return []
    }
    
    /// Toggle a bookmark. The returning bool being true indicates a bookmark having been added, instead of removed.
    func toggleBookmark(_ id: Int) -> Bool {
        let isBookmarked = self.isBookmarked(id)
        
        if isBookmarked {
            self.removeBookmark(id)
        } else {
            self.addBookmark(id)
        }
                
        return !isBookmarked
    }
    
    /// Add a bookmark
    func addBookmark(_ id: Int) {
        self.bookmarked[id] = Bookmark(bookmarkedAt: Date())
        
        UserDefaults.standard.setStruct(BookmarkIndex(bookmarked: self.bookmarked), forKey: HackerNewsBookmarks.bookmarkedItemsKey)
    }
    
    /// Remove a bookmark
    func removeBookmark(_ id: Int) {
        self.bookmarked.removeValue(forKey: id)
        
        UserDefaults.standard.setStruct(BookmarkIndex(bookmarked: self.bookmarked), forKey: HackerNewsBookmarks.bookmarkedItemsKey)
    }
    
    func isBookmarked(_ id: Int) -> Bool {
        return self.bookmarked[id] != nil
    }
    
    struct BookmarkIndex: Codable {
        let bookmarked: [Int: Bookmark]
    }
    
    struct Bookmark: Codable {
        let bookmarkedAt: Date
    }
}
