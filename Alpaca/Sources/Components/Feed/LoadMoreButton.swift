//
//  LoadMoreButton.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 23.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

struct LoadMoreButton: View {
    
    var moreItemsState: DataLoadingState<[FeedItem]>
    
    var action: () -> Void = {}
    
    var body: some View {
        self.moreItemsState.Switch(
            loading: {
                ActivityIndicatorView(isVisible: .constant(true), type: .flickeringDots)
                .frame(width: 30, height: 30)
                .foregroundColor(.secondary)
            }, success: { _ in
                Button(action: self.action) {
                    VStack {
                        Text("Load more")
                        .frame(alignment: .center)
                        Image(systemName: "chevron.compact.down")
                    }
                }
            }, failure: { error in
                Button(action: self.action) {
                    FeedError(error: .customMessage("Tap to try again"), horizontal: true)
                }
            }
        )
            .frame(maxWidth: .infinity)
            .frame(height: 100, alignment: .top)
            .font(.subheadline)
            .foregroundColor(Color.secondary)
    }
}

struct LoadMoreButton_Previews: PreviewProvider {
    static var previews: some View {
        LoadMoreButton(moreItemsState: .success([]))
    }
}
