//
//  VoicesView.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 20.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

struct CommentsView: View {
    
    @Binding var itemState: DataLoadingState<Item>
    
    var body: some View {
        itemState.Switch(
            loading: {
                Text("Loading")
            },
            success: { item in
                CommentList(article: item) { (type) in
                    switch type {
                    case .link(_):
//                        self.store.webViewStore.webView.load(URLRequest(url: url))
//                        self.store.showCommentSheet = false
                        break
                    default:
                        break
                    }
                }
               .edgesIgnoringSafeArea(.bottom)
            },
            failure: { error in
                Text("No comments yet :/ \(error)")
            }
        )
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        return CommentsView(itemState: .constant(.success(Item.mocked())))
    }
}
