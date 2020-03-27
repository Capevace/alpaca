//
//  DataLoadingState.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 23.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

enum DataLoadingState<DataType: Any> {
    case loading
    case success(DataType)
    case failure(String)
    
    struct Switch<T1: View, T2: View, T3: View>: View {
        var body: TupleView<(T1?, T2?, T3?)>
        
        init(
            value: DataLoadingState<DataType>,
            loading: @escaping () -> T1,
            success: @escaping (DataType) -> T2,
            failure: @escaping (String) -> T3
        ) {
            var v1: T1?
            var v2: T2?
            var v3: T3?
            
            switch value {
            case .loading:
                v1 = loading()
            case .success(let value):
                v2 = success(value)
            case .failure(let errorMessage):
                v3 = failure(errorMessage)
            }
            
            body = TupleView((v1, v2, v3))
        }
    }
    
    /// Emulates a switch directive handling a FeedDataState for SwiftUI views.
    func `Switch`<T1: View, T2: View, T3: View>(
        loading: @escaping () -> T1,
        success: @escaping (DataType) -> T2,
        failure: @escaping (String) -> T3
    ) -> Self.Switch<T1, T2, T3> {
        Self.Switch(
            value: self,
            loading: loading,
            success: success,
            failure: failure
        )
    }
    
    func from(_ result: Result<DataType, Error>) -> Self {
        switch result {
        case .success(let value):
            return .success(value)
            
        case .failure(let error):
            return .failure(error.localizedDescription)
        }
    }
}
