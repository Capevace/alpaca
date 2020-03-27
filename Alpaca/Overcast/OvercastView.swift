//
//  OvercastView.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 18.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

struct OvercastView: View {
    @State var index: Int = 0
    
    @ObservedObject var articleViewStore: ArticleStore
    
    init(_ feedItem: FeedItem) {
        self.articleViewStore = ArticleStore(feedItem, isDisplayed: .constant(true))
    }
    
    var body: some View {
        Text("Hello")
            .sheet(isPresented: .constant(true)) { 
                PageView(articleViewStore: self.articleViewStore)
            }
    }
}

struct OvercastView_Previews: PreviewProvider {
    static var previews: some View {
        OvercastView(FeedItem.mocked())
    }
}
