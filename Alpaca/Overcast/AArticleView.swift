//
//  AArticleView.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 18.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI
import WebView

struct AArticleView: View {
    
    var feedItem: FeedItem
        
    @State var active: Bool = true
    
    var body: some View {
//        WebView(webView: self.webViewStore.webView)
        VStack {
            Image("alpacaPlaceholder")
                .resizable()
    //            .scaledToFill()
                .clipped()
                .foregroundColor(Color.red)
                .onTapGesture {
                    withAnimation {
                        self.active.toggle()
                    }
                }
                .onAppear {
//                    self.webViewStore.webView.load(URLRequest(url: URL(string: self.articleViewStore.feedItem.url ?? "https://apple.com")!))
                }
        }
    }
}

struct AArticleView_Previews: PreviewProvider {
    static var previews: some View {
        AArticleView(feedItem: FeedItem.mocked())
    }
}
