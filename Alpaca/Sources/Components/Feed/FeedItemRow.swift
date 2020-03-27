//
//  FeedItemRow.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 04.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

struct FeedListRowContent: View {
    
    var feedItem: FeedItem
        
    var body: some View {
            VStack(alignment: .leading){
                HStack {
                    if self.feedItem.domain != nil {
                        Text(self.feedItem.domain!)
                    }
                    
                    Spacer(minLength: 0)
                    
                    
                }
                .font(Font.system(size: 12))
                .padding(.bottom, 5)
                    
                Text(self.feedItem.title)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.headline)
                    .foregroundColor(Color.mainTextColor)
                    .padding(.bottom, 5)
                
                HStack {
                    Text(self.feedItem.user ?? "[deleted]")
                        .font(Font.system(size: 12).weight(.bold))
                    Text(self.feedItem.timeAgo)
                        .font(Font.system(size: 12))
                }
                
                HStack {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "arrow.up")
                                .padding(.trailing, -5)
                            Text("\(self.feedItem.points ?? 0)")
                        }
                    }
                    
                    Spacer()
                        .frame(width: 12)
                    
                    Button(action: { print("hello") }) {
                        HStack {
                            Image(systemName: "text.bubble")
                                .padding(.trailing, -3)
                            Text("\(self.feedItem.commentsCount)")
                        }
                    }
                }
                .font(Font.system(size: 12))
            }
            .foregroundColor(Color.secondary)
            .padding(.leading, 7)
            .padding(.trailing, 5)
            .padding(.vertical, 5)
    }
}

struct FeedListRow: View {
    
    var feedItem: FeedItem
    
    @State var isDisplayed: Bool = false
    
    var body: some View {
        NavigationLink(destination: ArticleView(feedItem: feedItem, isDisplayed: self.$isDisplayed), isActive: self.$isDisplayed) {
            FeedListRowContent(feedItem: feedItem)
        }
    }
}

struct iPadFeedListRow: View {
    
    var feedItem: FeedItem
    
    @Binding var selectedItem: FeedItem?
    
    var body: some View {
        FeedListRowContent(feedItem: feedItem)
            .onTapGuesture {
                self.selectedItem = feedItem
            }
    }
}

struct FeedListRow_Previews: PreviewProvider {
    static var previews: some View {
        FeedListRow(feedItem: FeedItem.mocked())
    }
}
