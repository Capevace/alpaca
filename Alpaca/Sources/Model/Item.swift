//
//  Item.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 18.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import UIKit
import SwiftSoup

struct Item: Identifiable, Codable, Hashable {
    let id: Int // y
    let title: String // y, !
    let points: Int? // y
    let user: String? // y
    let time: Int // y
    let timeAgo: String // y
    let content: String
    let deleted: Bool?
    let dead: Bool?
    let type: String // y
    let url: String? // y
    let domain: String? // y
    let comments: [Item]
    let level: Int?
    let commentsCount: Int // y

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case points = "points"
        case user = "user"
        case time = "time"
        case timeAgo = "time_ago"
        case content = "content"
        case deleted = "deleted"
        case dead = "dead"
        case type = "type"
        case url = "url"
        case domain = "domain"
        case comments = "comments"
        case level = "level"
        case commentsCount = "comments_count"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.points = try container.decodeIfPresent(Int.self, forKey: .points)
        self.user = try container.decodeIfPresent(String.self, forKey: .user)
        self.time = try container.decode(Int.self, forKey: .time)
        self.timeAgo = try container.decode(String.self, forKey: .timeAgo)
        
        let content = try container.decode(String.self, forKey: .content)
        
//        if !content.hasSuffix("</p>") {
//            self.content = content + "</p>"
//        } else {
//            self.content = content
//        }
        
        do {
            let soup = try SwiftSoup.parseBodyFragment(content)
            let elements = (try? soup.select("a")) ?? Elements()
            
            for element in elements {
                let url = try! element.attr("href")
                try! element.text(url)
            }
            
            if let body = soup.body() {
                self.content = try body.html()
            } else {
                self.content = content
            }
        } catch {
            // TODO: add error handling, we found a case where the HTML thing failed
            self.content = content
        }
        
        self.deleted = try container.decodeIfPresent(Bool.self, forKey: .deleted)
        self.dead = try container.decodeIfPresent(Bool.self, forKey: .dead)
        self.type = try container.decode(String.self, forKey: .type)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.domain = try container.decodeIfPresent(String.self, forKey: .domain)
        self.level = try container.decodeIfPresent(Int.self, forKey: .level)
        self.commentsCount = try container.decode(Int.self, forKey: .commentsCount)

        self.comments = try container.decode([Item].self, forKey: .comments)
    }

    init(from feedItem: FeedItem) {
        self.id = feedItem.id
        self.title = feedItem.title
        self.points = feedItem.points
        self.user = feedItem.user
        self.time = feedItem.time
        self.timeAgo = feedItem.timeAgo
        self.content = ""
        self.deleted = nil
        self.dead = nil
        self.type = feedItem.type
        self.url = feedItem.url
        self.domain = feedItem.domain
        self.comments = []
        self.level = nil
        self.commentsCount = 0
    }
    
    func feedItem() -> FeedItem {
        FeedItem(id: self.id, title: self.title, type: self.type, commentsCount: self.commentsCount, time: self.time, timeAgo: self.timeAgo, points: self.points, user: self.user, url: self.url, domain: self.domain)
    }

    static func mocked() -> Item {
        let data = NSDataAsset(name: "demoItem")!.data
        return try! JSONDecoder().decode(Item.self, from: data)
    }
}

/// CommentItem is a subclass of AbstractComment (used by UIKit / SwiftyComments abstractions) and implements an Item as the data source.
class CommentItem: AbstractComment {
    var level: Int! {
        get {
            return self.item.level ?? 0
        }
        set {}
    }
    
    var item: Item
    
    var parent: CommentItem?
    
    init(item: Item, parent: CommentItem? = nil) {
        self.item = item
        self.parent = parent
        self.replies = self.item.comments.map { comment in
            CommentItem(item: comment, parent: self)
        }
    }
    
    
    var replies: [AbstractComment]!
    
    var replyTo: AbstractComment? {
        get {
            return self.parent
        }
        set {}
    }
    
    class func from(_ article: Item) -> [CommentItem] {
        return article.comments.map { (item) -> CommentItem in
            CommentItem(item: item, parent: nil)
        }
    }
}

