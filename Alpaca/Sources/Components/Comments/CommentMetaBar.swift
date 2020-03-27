//
//  CommentMetaBar.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 22.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

struct CommentMetaBar: View {
    
    @ObservedObject var store: BookmarkStore
    
    let feedItem: FeedItem
    var transitionProgress: CGFloat
    private let toggleSheetAction: () -> Void
    private let dismissArticleView: () -> Void
    
    init(_ feedItem: FeedItem, transitionProgress: CGFloat, toggleSheetAction: @escaping () -> Void = {}, dismissArticleView: @escaping () -> Void = {}) {
        self.feedItem = feedItem
        self.store = BookmarkStore(feedItem)
        self.transitionProgress = transitionProgress
        self.toggleSheetAction = toggleSheetAction
        self.dismissArticleView = dismissArticleView
    }
    
    var body: some View {
        ZStack(alignment: Alignment.top) {
            // MinimizedView
            ZStack {
                HStack {
                    Spacer()
                    .frame(width: 20)
                    
                    Button(action: self.dismissArticleView) {
                        HStack {
                            Image(systemName: "chevron.left")
                            
                            Text("Back")
                        }
                        .font(Font.system(size: 11.0))
                        
                    }
                    
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "line.horizontal.3")
                    
                    Spacer()
                        .frame(width: 15)
                    
                    Text("\(self.feedItem.commentsCount) comments")
                    .font(Font.system(size: 11.0))
                }
            }
            .foregroundColor(Color.secondary)
            .offset(y: 10)
            .opacity(self.minimizedViewOpacity)
            .frame(alignment: .top)

            // Expanded View
            HStack (alignment: .top) {
                // Title stack
                VStack(alignment: .leading){
                   Text(self.feedItem.title)
                        .lineLimit(nil)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.headline)
                    .foregroundColor(.mainTextColor)
                        .padding(.bottom, -5)
                    
                    HStack {
                        Text(self.feedItem.user ?? "[deleted]")
                            .font(Font.system(size: 12).weight(.bold))
                        Text(self.feedItem.timeAgo)
                        .font(Font.system(size: 12))
                        
                        Spacer()
                        .frame(width: 12)
                        
                        HStack {
                            HStack {
                                Image(systemName: "arrow.up")
                                    .padding(.trailing, -5)
                                Text("\(self.feedItem.points ?? 0)")
                            }
                            
                            Spacer()
                                .frame(width: 12)
                            
                            HStack {
                                Image(systemName: "text.bubble")
                                    .padding(.trailing, -3)
                                Text("\(self.feedItem.commentsCount)")
                            }
                        }
                        .font(Font.system(size: 12))
                        .foregroundColor(Color.secondary)
                    }
                    .font(Font.system(size: 14))
                    .foregroundColor(Color.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .opacity(self.expandedViewOpacity)

                Spacer()

                // Chevron and bookmark buttons
                HStack {
                    Button(action: self.store.toggleBookmark) {
                        Image(systemName: self.store.isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 20))
                    }
                    .foregroundColor(Color.secondary)
                    .opacity(self.expandedViewOpacity)

                    Spacer()
                    .frame(width: 10)

                    Button(action: self.toggleSheetAction) {
                        Image(systemName: "chevron.up")
                        .font(.system(size: self.chevronFontSize))
                    }
                    .foregroundColor(Color.secondary)
                    .offset(y: self.chevronOffset)
                    .rotationEffect(self.chevronRotation)
                    .padding(10)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
    }
    
    /// Transitional opacity for the view that is displayed when the sheet is minimized.
    var minimizedViewOpacity: Double {
        // Progress is subtracted from 1.0 to invert the value, as the minimized view should lose opacity as the transition progresses.
        1.0 - Double(self.transitionProgress * 5)
    }
    
    /// Transitional opacity for the view that is displayed when the sheet is expanded.
    var expandedViewOpacity: Double {
        // Took me a while to figure this calculation out so here's an explanation:
        // The expanded view should only start appearing after 20% transition progress.
        // The `- 0.2` makes sure that the opacity only goes above 0 after the transition is past 20%.
        // However because of that, the resulting value's maximum is only 0.8, meaning opacity will never reach 100%.
        // Thats why a division by 0.8 is required in order to restore 0-100% progress range (as in 0.8/0.8 == 1).
        Double((self.transitionProgress - 0.2) / 0.8)
    }
    
    
    /// Transitional font size for the chevron arrow as it grows during transition.
    var chevronFontSize: CGFloat {
        11.0 + (self.transitionProgress * 9)
    }
    
    /// Transitional y-offset for the chevron arrow as it moves up during transition.
    var chevronOffset: CGFloat {
        (1 - self.transitionProgress) * -7
    }
    
    /// Transitional rotation for the chevron arrow as it rotates by 180 degrees during transition.
    var chevronRotation: Angle {
        Angle(degrees: Double(180.0 * self.transitionProgress))
    }
}

struct CommentMetaBar_Previews: PreviewProvider {
    static var previews: some View {
        CommentMetaBar(FeedItem.mocked(), transitionProgress: 0.0, toggleSheetAction: {})
    }
}
