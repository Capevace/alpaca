//
//  MasterView.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 20.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

struct MasterView: View {
    
    @EnvironmentObject var store: FeedStore
        
    var body: some View {
        VStack {
            Picker("Select Category", selection: $store.selectedCategory) {
                Text("Top")
                .tag(HackerNewsCategory.top.rawValue)

                Text("New")
                .tag(HackerNewsCategory.new.rawValue)

                Text("Show")
                .tag(HackerNewsCategory.show.rawValue)

                Text("Ask")
                .tag(HackerNewsCategory.ask.rawValue)

                Text("Jobs")
                .tag(HackerNewsCategory.jobs.rawValue)

                Image(systemName: "bookmark")
                .tag(HackerNewsCategory.bookmarked.rawValue)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 20)
            
            self.store.feedState.Switch(
                loading: {
                    ActivityIndicatorView(isVisible: .constant(true), type: .flickeringDots)
                    .frame(width: 30, height: 30)
                    .frame(maxHeight: .infinity)
                    .foregroundColor(.secondary)
                },
                success: { feedItems in
                    FeedList(
                        items: feedItems,
                        moreItemsState: self.store.moreItemsState,
                        loadMoreAction: self.store.fetchNextPage,
                        showMoreButton: self.store.category != .bookmarked
                    )
                },
                failure: { message in
                    FeedError(error: .noMessage)
                }
            )
        }
        .edgesIgnoringSafeArea(.init(arrayLiteral: .bottom, .horizontal))
        .navigationBarTitle(store.category.name)
    }
}


struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView()
            .environmentObject(FeedStore.mocked(.failure("")))
    }
}
