//
//  URL+Identifiable.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 20.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import Foundation

extension URL: Identifiable {
    public var id: ObjectIdentifier {
        ObjectIdentifier(URL.self)
    }
}
