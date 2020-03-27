//
//  SafariWebView.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 20.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI
import SafariServices

/// A container view for using a SFSafariViewController in SwiftUI.
struct SafariViewContent: UIViewControllerRepresentable {
    
    public typealias UIViewControllerType = SFSafariViewController
    
    let store: SafariStore
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<SafariViewContent>) -> SFSafariViewController {
        return store.safariViewController!
    }
    
    public func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariViewContent>) {}
}

struct SafariView: View {
    
    @ObservedObject var store: SafariStore

    var body: some View {
        if store.ready {
            return AnyView(SafariViewContent(store: store))
        }
        
        return AnyView(EmptyView())
    }
}

//struct SafariView_Previews: PreviewProvider {
//    static var previews: some View {
//        SafariView(url: FeedItem.mocked().safeUrl)
//    }
//}
