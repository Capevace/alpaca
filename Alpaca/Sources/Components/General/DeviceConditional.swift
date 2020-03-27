//
//  DeviceConditional.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 20.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

struct DeviceConditional<T1: View, T2: View>: View {
    var body: TupleView<(T1?, T2?)>
    
    init(
        phone: @escaping () -> T1,
        pad: @escaping () -> T2
    ) {
        var v1: T1?
        var v2: T2?
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            v1 = phone()
        case .pad:
            v2 = pad()
        default:
            break
        }
        
        body = TupleView((v1, v2))
    }
}

struct DeviceConditional_Previews: PreviewProvider {
    static var previews: some View {
        DeviceConditional(
            phone: {
                Text("iPhone")
            }, pad: {
                Text("iPad")
            }
        )
    }
}
