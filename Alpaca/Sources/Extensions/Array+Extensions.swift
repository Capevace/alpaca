//
//  Array+Extensions.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 24.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
