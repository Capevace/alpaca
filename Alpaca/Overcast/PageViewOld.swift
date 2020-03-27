//
//  PageViewOld.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 18.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

//struct PageView: View {
////    let pages: [PageViewData]
//    
//    let numberOfPages: Int = 2
//    
//    @ObservedObject var articleViewStore: ArticleViewStore
//    
//    @State var index: Int = 0
//    @State private var offset: CGFloat = 0
//    @State private var isUserSwiping: Bool = false
//    
//    let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
//    
//    private func scaleForOffset(_ width: CGFloat) -> CGFloat {
//        var scale = 1 - (abs(self.offset / width))
//        scale = min(scale, 1)
//        scale = max(scale, 0.75)
//        
//        return scale
//    }
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(alignment: .center, spacing: 0) {
//                    AArticleView(feedItem: self.articleViewStore.feedItem)
//                        .mask(
//                            RoundedRectangle(cornerRadius: self.index == 0 ? 0.0 : 50.0)
//                                .scale(self.index == 0 ? self.scaleForOffset(geometry.size.width) : 0.75)
//                                .animation(.easeOut)
//                        )
//                        .frame(width: geometry.size.width,
//                        height: geometry.size.height)
//                    
//                    AArticleView(feedItem: self.articleViewStore.feedItem)
//                        .mask(
//                            RoundedRectangle(cornerRadius: 50.0)
//                                .scale(self.index == 1 ? self.scaleForOffset(geometry.size.width) : 0.75)
//                        )
//                        .frame(width: geometry.size.width,
//                        height: geometry.size.height)
//                }
//            }
//            .content
//            .offset(x: self.isUserSwiping ? self.offset : CGFloat(self.index) * -geometry.size.width)
//            .frame(width: geometry.size.width, alignment: .leading)
//            .gesture(
//                DragGesture()
//                    .onChanged({ value in
//                        self.isUserSwiping = true
//                        self.offset = value.translation.width + -geometry.size.width * CGFloat(self.index)
//                        print(self.offset)
//                    })
//                    .onEnded({ value in
//                        print(value.predictedEndTranslation.width, self.offset, geometry.size.width/2)
//                        let width = geometry.size.width / 2
//                        if value.predictedEndTranslation.width < -width, self.index < self.numberOfPages - 1 {
//                            self.index += 1
//                        }
//                        if value.predictedEndTranslation.width > width, self.index > 0 {
//                            self.index -= 1
//                        }
////                        withAnimation {
////                            self.isUserSwiping = false
////                        }
//                        
//                        withAnimation(.interactiveSpring()) {
//                            self.isUserSwiping = false
//                            self.selectionFeedbackGenerator.selectionChanged()
//                        }
//                        
//                        withAnimation(.easeOut(duration: 0.2)) {
//                            self.offset = 0
//                        }
//                    })
//            )
//        }
//    }
//}
//
//struct PageView_Previews: PreviewProvider {
//    static var previews: some View {
//        PageView(articleViewStore: ArticleViewStore(feedItem: FeedItem.mocked()))
//    }
//}
