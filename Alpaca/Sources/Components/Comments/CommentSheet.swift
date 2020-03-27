//
//  CommentTabBar.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 21.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

/// Draggable sheet view that contains an item's comments.
struct CommentSheet: View {
    
    /// Height that the CommentSheet should have while minimized.
    static let minimizedHeight: CGFloat = 110.0
    
    @EnvironmentObject var store: ArticleStore
    
    /// Expansion state for the sheet
    @State private var cardState: CardExpansionState = .minimized
    
    /// State for the drag guesture.
    @GestureState private var dragState = DragState.inactive
    
    /// Vibration generator
    private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // MARK: Variable Height Spacer
                Spacer()
                    .frame(height: self.topSpacerHeight)
                
                CommentMetaBar(self.store.feedItem, transitionProgress: self.transitionProgress, toggleSheetAction: self.toggleCardState, dismissArticleView: self.store.dismissArticleView)
                
                CommentsView(itemState: self.$store.itemStore.itemState)
                    .opacity(self.contentViewOpacity)
                
                Spacer(minLength: 0)
            }
            .background(Color.articleBackground)
            .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
            .frame(height: UIScreen.main.bounds.height)
            .position(x: geometry.size.width/2,  y: UIScreen.main.bounds.height * 1.5 - CommentSheet.minimizedHeight)
            .offset(y: self.offset)
            .gesture(
                DragGesture()
                    .updating(self.$dragState, body: { drag, state, _ in
                        print("d", drag.startLocation)
                        if self.cardState == .minimized || self.cardState == .expanded && drag.startLocation.y < 82 {
                            state = .dragging(translation: drag.translation)
                        }
                    })
                    .onEnded(self.onDragEnded(drag:))
            )
        }
    }
    
    /// The progess of the transition from .minimized to .expanded state.
    ///
    /// The progress ranges from 0.0 to 1.0 and is used to animate the transition between the two states.
    /// 0.0 = .minimized, 1.0 = .expanded
    var transitionProgress: CGFloat {
        let value: CGFloat!
        
        // While we are dragging the sheet, we need to add the drag translation to the sheet
        if self.dragState.isDragging {
            let sheetOffset = (abs(self.cardState.position()) - self.dragState.translation.height)
            let maxOffset = abs(CardExpansionState.expanded.position())
            
            let progress = sheetOffset / maxOffset
            
            // Limit progress to 0.0 and 1.0
            value = min(1.0, max(0.0, progress))
        } else {
            // When we are not dragging we can simply return the expected values for a given state.
            // SwiftUI then animates the progress to the end state, we don't need to do that manually or anything stupid like that.
            value = self.cardState == .expanded
                ? 1.0
                : 0.0
        }
        
        return value
    }
    
    /// Offset that the sheet is moved by on the y-axis.
    ///
    /// This offset is basically what makes the view a draggable sheet.
    var offset: CGFloat {
        let offset = self.dragState.isDragging ? self.cardState.position() + self.dragState.translation.height : self.cardState.position()
        
        // The topSpacerHeight is subtracted from the position to account for the added height during transition
        print(self.cardState.position(), self.dragState.translation.height, offset - topSpacerHeight)
        return offset - topSpacerHeight
    }
    
    /// Space that gets added to the top of the sheet in order to fill the status bar area with color too.
    ///
    /// This is done so the SFSafariViewController gets properly hidden under the CommentSheet, and doesn't leak at the status bar.
    /// See MARK "Variable Height Spacer" for implementation.
    var topSpacerHeight: CGFloat {
        self.transitionProgress * 60
    }
    
    /// Transitional opacity for the content view.
    var contentViewOpacity: Double {
        // Took me a while to figure this calculation out so here's an explanation:
        // The expanded view should only start appearing after 20% transition progress.
        // The `- 0.2` makes sure that the opacity only goes above 0 after the transition is past 20%.
        // However because of that, the resulting value's maximum is only 0.8, meaning opacity will never reach 100%.
        // Thats why a division by 0.8 is required in order to restore 0-100% progress range (as in 0.8/0.8 == 1).
        Double((self.transitionProgress - 0.2) / 0.8)
    }
    
    
    /// Toggles the current card state between .minimized and .expanded.
    private func toggleCardState() {
        switch self.cardState {
        case .expanded:
            self.cardState = .minimized
        case .minimized:
            self.cardState = .expanded
        }
    }
    
    /// Updates the drag state with the new translation.
    private func onDragUpdated(drag: DragGesture.Value, state: inout DragState, transaction: inout Transaction) {
        
    }
    
    /// Sets the card state according to the predicted end location of the drag guesture.
    ///
    /// If the state changed, a selection feedback vibration will be played.
    private func onDragEnded(drag: DragGesture.Value) {
        let oldPos = self.cardState
        
        if drag.predictedEndLocation.y < UIScreen.main.bounds.height/2 {
            self.cardState = .expanded
        } else {
            self.cardState = .minimized
        }
        
        if oldPos != self.cardState {
            self.selectionFeedbackGenerator.selectionChanged()
        }
    }
    
    /// State container for the drag guesture.
    enum DragState {
        case inactive
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactive:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
        
        var isDragging: Bool {
            switch self {
            case .inactive:
                return false
            case .dragging:
                return true
            }
        }
    }
    
    /// State for the sheet (minimized / expanded).
    enum CardExpansionState {
        case expanded
        case minimized
        
        func position() -> CGFloat {
            switch self {
            case .expanded:
                return -1 * (UIScreen.main.bounds.height - 110)
            case .minimized:
                return 0
            }
        }
    }

}

struct CommentSheet_Previews: PreviewProvider {
    static var previews: some View {
        CommentSheet()
            .environmentObject(ArticleStore.mocked())
    }
}

