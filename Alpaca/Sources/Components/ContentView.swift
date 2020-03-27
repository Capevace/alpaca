//
//  ContentView.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 04.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        DeviceConditional(
            phone: {
                iPhoneContent()
            }, pad: {
                iPadContent()
            }
        )
    }
}

struct iPhoneContent: View {
    
    @EnvironmentObject var store: FeedStore
    
    var body: some View {
        NavigationView {
            MasterView()
        }
    }
}

struct iPadContent: View {
    
    @EnvironmentObject var store: FeedStore
    
    @ObservedObject var detailStore: DetailStore = DetailStore()
    
    var body: some View {
        NavigationView {
            MasterView()
            
            if self.store.selectedItem == nil {
                Text("Is this in the detail view?")
            } else {
                ArticleView(feedItem: self.store.selectedItem!, isDisplayed:.constant(true))
            }
        }.onAppear {
            self.$store.
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FeedStore.mocked())
    }
}
