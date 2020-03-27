//
//  ItemView.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 18.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

struct PageView: View {
//    let pages: [PageViewData]
    
    let numberOfPages: Int = 2
    
    @ObservedObject var articleViewStore: ArticleStore
    
    @State var index: Int = 0
    @State private var offset: CGFloat = 0
    @State private var isUserSwiping: Bool = false
    
    let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    
//    private func scaleForOffset(_ width: CGFloat) -> CGFloat {
//        var scale = 1 - (abs(self.offset / width))
//        scale = min(scale, 1)
//        scale = max(scale, 0.75)
//
//        return scale
//    }
    
    func radiusForOffset(offset: CGFloat, width: CGFloat) -> CGFloat {
        let finalRadius: CGFloat = 50.0
        
        let part = width / 5.0
        let absOffset = abs(offset)
        
        if absOffset > part {
            return finalRadius
        }
        
        let value = absOffset / part * finalRadius
        
        print(value)
        
        return value
    }
    
    func scaleForOffset(offset: CGFloat, width: CGFloat) -> CGFloat {
            let finalScale: CGFloat = 0.9
            let perc: CGFloat = 1 - finalScale // 0.25
            
            let part = width / 5.0
            let absOffset = abs(offset)
    
            if absOffset > part {
                return finalScale
            }
    
            let value = 1.0 - ((absOffset / part) * perc)
    
            print(value)
            
            return value
        }
    
    var body: some View {
        GeometryReader { geometry in
//            var x = self.offset// - geometry.size.width
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 0) {
                    AArticleView(feedItem: self.articleViewStore.feedItem)
                        .mask(
                            RoundedRectangle(cornerRadius: self.radiusForOffset(offset: self.offset, width: geometry.size.width))
                                .scale(self.scaleForOffset(offset: self.offset, width: geometry.size.width))
                        )
                        .frame(width: geometry.size.width,
                        height: geometry.size.height)
                    
                    VStack {
                        HStack {
                            Text("Hello")
                            Spacer()
                        }.background(Color.secondary)
                        
                        HStack {
                            Text("Hello")
                            Spacer()
                        }.background(Color.secondary)
                        
                        HStack {
                            Text("Hello")
                            Spacer()
                        }.background(Color.secondary)
                    }.frame(width: geometry.size.width,
                    height: geometry.size.height)
                }
            }
            .content
            .offset(x: self.isUserSwiping ? self.offset : CGFloat(self.index) * -geometry.size.width)
            .frame(width: geometry.size.width, alignment: .leading)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        self.isUserSwiping = true
                        self.offset = value.translation.width + -geometry.size.width * CGFloat(self.index)
                        
                        print(self.offset)
                    })
                    .onEnded({ value in
//                        print(value.predictedEndTranslation.width, self.offset, geometry.size.width/2)
                        
                        let width = geometry.size.width / 2
                        if value.predictedEndTranslation.width < -width, self.index < self.numberOfPages - 1 {
                            self.index += 1
                        }
                        if value.predictedEndTranslation.width > width, self.index > 0 {
                            self.index -= 1
                        }
//                        withAnimation {
//                            self.isUserSwiping = false
//                        }
                        
                        withAnimation(.interactiveSpring()) {
                            self.isUserSwiping = false
                            self.selectionFeedbackGenerator.selectionChanged()
                        }
                        
                        withAnimation(.easeOut(duration: 0.2)) {
                            self.offset = 0
                        }
                    })
            )
        }
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(articleViewStore: ArticleStore(FeedItem.mocked(), isDisplayed: .constant(true)))
    }
}
