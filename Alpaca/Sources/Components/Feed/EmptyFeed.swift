//
//  EmptyFeed.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 25.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

struct EmptyFeed: View {
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 75)
            Image(systemName: "bookmark.fill")
                .font(.system(size: 60))
                .foregroundColor(Color.white)
                .frame(width: 125, height: 125)
                .background(Color.secondary.opacity(0.2))
                .mask(Circle())
            
            Spacer()
                .frame(height: 30)
            
            Text("No items bookmarked")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .frame(maxHeight: .infinity)
    }
}

struct EmptyFeed_Previews: PreviewProvider {
    static var previews: some View {
        EmptyFeed()
    }
}
