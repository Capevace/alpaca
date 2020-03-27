//
//  FeedList.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 22.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

struct FeedList: View {
        
    var items: [FeedItem]
        
    var moreItemsState: DataLoadingState<[FeedItem]> = .success([])
    
    var loadMoreAction: () -> Void = {}
    
    var showMoreButton: Bool = true
    
//    var listHeader: some View {
//        Picker("Select Category", selection: $selectedCategory) {
//            Text("Top")
//            .tag(HackerNewsCategory.top.rawValue)
//
//            Text("New")
//            .tag(HackerNewsCategory.new.rawValue)
//
//            Text("Show")
//            .tag(HackerNewsCategory.show.rawValue)
//
//            Text("Ask")
//            .tag(HackerNewsCategory.ask.rawValue)
//
//            Text("Jobs")
//            .tag(HackerNewsCategory.jobs.rawValue)
//
//            Image(systemName: "bookmark")
//            .tag(HackerNewsCategory.bookmarked.rawValue)
//        }
//        .pickerStyle(SegmentedPickerStyle())
//        .padding(.horizontal, 20)
//    }
    
    var listFooter: some View {
        return Conditional(showMoreButton,
            true: {
                LoadMoreButton(moreItemsState: self.moreItemsState, action: self.loadMoreAction)
            },
            false: {
                EmptyView()
            }
        )
    }
    
    var body: some View {
        Conditional(
            self.items.count > 0,
            true: {
                List {
                    Section(footer: self.listFooter) {
                        ForEach(self.items, id: \.self) { feedItem in
                            FeedListRow(feedItem: feedItem)
                        }
                    }
                }
            },
            false: {
                EmptyFeed()
            }
        )
    }
}

struct FeedList_Previews: PreviewProvider {
    static var previews: some View {
        return FeedList(items: [
            FeedItem.mocked(),
            FeedItem.mocked(),
            FeedItem.mocked(),
            FeedItem.mocked(),
            FeedItem.mocked(),
            FeedItem.mocked()
        ])
    }
}
