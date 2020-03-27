//
//  HackerNewsAPI.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 19.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import UIKit
import Alamofire

enum HackerNewsCategory: Int {
    case bookmarked
    case top
    case new
    case show
    case ask
    case jobs
    
    var name: String {
        switch self {
        case .bookmarked:
            return "Bookmarked"
        case .top:
            return "Top"
        case .new:
            return "New"
        case .show:
            return "Show"
        case .ask:
            return "Ask"
        case .jobs:
            return "Jobs"
        }
    }
    
    var urlKey: String {
        switch self {
        case .bookmarked:
            return ""
        case .top:
            return "news"
        case .new:
            return "newest"
        case .show:
            return "show"
        case .ask:
            return "ask"
        case .jobs:
            return "jobs"
        }
    }
}

class HackerNewsAPI {
    
    let session = Session.default
    
    func getFeed(_ category: HackerNewsCategory = .top, _ page: Int = 0, _ handler: @escaping (Result<[FeedItem], Error>) -> Void) {
        AF
            .request("https://api.hnpwa.com/v0/\(category.urlKey)/\(page + 1).json")
            .responseDecodable(completionHandler: transformAlamofireHandler(handler))
    }
    
    func getItem(_ id: Int, handler: @escaping (Result<Item, Error>) -> Void) {
        AF
            .request("https://api.hnpwa.com/v0/item/\(id).json")
            .responseDecodable(completionHandler: transformAlamofireHandler(handler))
        
        //GET http://hn.algolia.com/api/v1/items/:id
    }
    
    /// Alamofire uses AFError, however I have not figured out how to cast the `Result<Item, AFError>` to `Result<Item, Error>`.
    private func transformAlamofireHandler<T>(_ handler: @escaping (Result<T, Error>) -> Void) -> (DataResponse<T, AFError>) -> Void {
        return { response in
            switch response.result {
            case .success(let value):
                handler(.success(value))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}

