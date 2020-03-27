//
//  FeedItem.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 18.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import Foundation

struct FeedItem: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let type: String
    let commentsCount: Int
    let time: Int
    let timeAgo: String
    let points: Int?
    let user: String?
    let url: String?
    let domain: String?
    
    var hackerNewsUrl: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "news.ycombinator.com"
        components.path = "/item"
        components.queryItems = [
            URLQueryItem(name: "id", value: String(self.id))
        ]
        
        return components.url!
    }
    
    var safeUrl: URL {
        return self.url != nil && !self.url!.starts(with: "item?id=")
           ? URL(string: self.url!) ?? self.hackerNewsUrl
           : self.hackerNewsUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case type = "type"
        case commentsCount = "comments_count"
        case time = "time"
        case timeAgo = "time_ago"
        case points = "points"
        case user = "user"
        case url = "url"
        case domain = "domain"
    }
    
    static func mocked() -> FeedItem {
        let id = Int.random(in: 0...10000)
        
        let longTitle = "Long Title with Story \(id) that might be very long (2017)"
        let shortTitle = "This Short \(id) will surprise you"
        
        return FeedItem(id: id, title: Int.random(in: 0...1) == 0 ? longTitle : shortTitle, type: "story", commentsCount: Int.random(in: 0...650), time: 0, timeAgo: "\(Int.random(in: 10...59))s ago", points: Int.random(in: 10...980), user: "anonymous", url: "https://google.com", domain: "google.com")
    }
    
    static func mockedArray() -> [FeedItem] {
        [
            FeedItem.mocked(),
            FeedItem.mocked(),
            FeedItem.mocked(),
            FeedItem.mocked(),
            FeedItem.mocked(),
            FeedItem.mocked()
        ]
    }
}
