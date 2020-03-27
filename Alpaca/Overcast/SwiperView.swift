//
//  PageView.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 18.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

struct SwiperView<Content>: View where Content: View {
//    let pages: [PageViewData]
    
    let numberOfPages: Int
    
    @State var index: Int = 0
    @State private var offset: CGFloat = 0
    @State private var isUserSwiping: Bool = false
    
    let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    
    let content: (CGFloat) -> Content
    
    @inlinable public init(_ numberOfPages: Int, @ViewBuilder content: @escaping (CGFloat) -> Content) {
        self.numberOfPages = numberOfPages
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 0) {
                    self.content(self.offset / geometry.size.width)
                        .frame(width: geometry.size.width,
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
                        print(value.predictedEndTranslation.width, self.offset, geometry.size.width/2)
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
                    })
            )
        }
    }
}

struct SwiperView_Previews: PreviewProvider {
    static var previews: some View {
        SwiperView(3) {_ in 
            Image("alpacaPlaceholder")
                .resizable()
                .clipped()
            Text("Hello")
            Image("alpacaPlaceholder")
                .resizable()
                .clipped()
        }
    }
}
