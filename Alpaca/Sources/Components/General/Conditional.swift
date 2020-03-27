//
//  Conditional.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 24.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

//
//  DeviceConditional.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 20.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

/// A conditional wrapper view that helps with view type errors.
struct Conditional<T1: View, T2: View>: View {
    var body: TupleView<(T1?, T2?)>
    
    init(
        _ value: Bool,
        true: @escaping () -> T1,
        false: @escaping () -> T2
    ) {
        var v1: T1?
        var v2: T2?
        
        if value {
            v1 = `true`()
        } else {
            v2 = `false`()
        }
        
        body = TupleView((v1, v2))
    }
}

struct Conditional_Previews: PreviewProvider {
    static var previews: some View {
        Conditional(
            true,
            true: {
                Text("The given value was true")
            }, false: {
                Text("The given value was false")
            }
        )
    }
}
