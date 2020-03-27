//
//  Color+Extensions.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 17.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

extension Color {
    static let accentColor = Color("accentColor")
    static let articleBackground = Color("articleBackground")
    static let mainTextColor = Color("mainTextColor")
}

extension UIColor {
    // lightmode/darkmode
    
    // orange
    static let accentColor = UIColor(named: "accentColor")!
    
    // light/dark gray
    static let articleBackground = UIColor(named: "articleBackground")!
    
    // light/dark gray
    static let commentsBackground = UIColor(named: "commentsBackground")!
    
    // dark/light gray
    static let mainTextColor = UIColor(named: "mainTextColor")!
    
    // dark/light gray
    static let commentTextColor = UIColor(named: "commentTextColor")!
}
