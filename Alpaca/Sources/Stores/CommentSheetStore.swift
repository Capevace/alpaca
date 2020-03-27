//
//  CommentSheetStore.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 23.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

class CommentSheetStore: ObservableObject {
    
    @Published var showCommentSheet: Bool = false
    
    let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    
    func toggleSheet() {
        self.showCommentSheet.toggle()
    }
}
