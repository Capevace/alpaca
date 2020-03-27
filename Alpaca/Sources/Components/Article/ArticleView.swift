//
//  ArticleView.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 05.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI
import WebView
import WebKit



struct ArticleView: View {
    
    @ObservedObject var store: ArticleStore
    
    init(feedItem: FeedItem, isDisplayed: Binding<Bool>) {
        self.store = ArticleStore(feedItem, isDisplayed: isDisplayed)
    }
    
    var body: some View {
//        Implement conditional for iPad later:
//        DeviceConditional(
//            phone: {
//                ArticleViewiPhone()
//            }, pad: {
//                ArticleViewiPad()
//            }
//        )
        ArticleViewiPhone()
            .environmentObject(self.store)
            .onAppear(perform: self.store.setup)
    }
}





struct ArticleViewiPhone: View {
    
    var body: some View {
        ZStack(alignment: Alignment.top) {
            Color.articleBackground
            
            BrowserView()
                .frame(height: UIScreen.main.bounds.height - CommentSheet.minimizedHeight)
            
            CommentSheet()
                .navigationBarHidden(true)
                .navigationBarTitle("Hacker News", displayMode: .inline)
        }
    }
    
}

struct ArticleViewiPad: View {
            
    var body: some View {
        ZStack(alignment: Alignment.top) {
            Color.articleBackground
            
            BrowserView()
                .frame(height: UIScreen.main.bounds.height - CommentSheet.minimizedHeight)
            
            CommentSheet()
                .navigationBarHidden(true)
                .navigationBarTitle("Hacker News", displayMode: .inline)
        }
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(feedItem: FeedItem.mocked(), isDisplayed: .constant(true))
    }
}

