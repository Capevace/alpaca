//
//  BrowserView.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 20.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI
import WebView

struct BrowserView: View {
    
    @EnvironmentObject var store: ArticleStore
        
    var body: some View {

        SafariView(store: store.safariStore)
        .edgesIgnoringSafeArea(.top)
        
    }
    
}

struct BrowserView_Previews: PreviewProvider {
    static var previews: some View {
        BrowserView()
            .environmentObject(ArticleStore.mocked())
    }
}
