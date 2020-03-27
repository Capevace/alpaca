//
//  FeedError.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 25.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI

enum FeedErrorType {
    case unknown
    case customMessage(String)
    case noMessage
    case network
    case incompatible
    
    var message: String {
        switch self {
        case .customMessage(let message):
            return message
        case .noMessage:
            return ""
        case .unknown:
            return "An unknown error occurred."
        case .network:
            return "No internet connection."
        case .incompatible:
            return "App incompatible with new Hacker News API."
        }
    }
    
    var retryable: Bool {
        switch self {
        case .incompatible:
            return false
        default:
            return true
        }
    }
}

struct FeedError: View {
    
    var error: FeedErrorType
    
    var horizontal: Bool = false
    
    var horizontalBody: some View {
        HStack {
            Image(systemName: "xmark.circle.fill")
            .font(.system(size: 40))
            .foregroundColor(Color.secondary)
            .frame(width: 40, height: 40)
//                .background(Color.secondary)
            .opacity(0.2)
            
            Spacer()
                .frame(maxWidth: 25)
            
            VStack(alignment: .leading) {
                Text("Unable to load more")
                .font(.headline)
                .foregroundColor(.secondary)
                
                Text(error.message)
                .lineLimit(nil)
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
    }
    
    var verticalBody: some View {
        VStack {
            Spacer()
                .frame(height: 75)
            
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 120))
                .foregroundColor(Color.secondary)
                .frame(width: 125, height: 125)
//                .background(Color.secondary)
                .opacity(0.2)
//                .mask(Circle())
            
            Spacer()
                .frame(height: 30)
            
            Text("Unable to load feed")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Spacer()
            .frame(height: 10)
            
            Text(error.message)
            .lineLimit(nil)
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            if error.retryable {
                Spacer()
                .frame(height: 25)
                
                Button(action: {}) {
                    Text("Try again")
                    .font(.subheadline)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 20)
    }
    
    var body: some View {
        Conditional(
            horizontal,
            true: {
                self.horizontalBody
            },
            false: {
                self.verticalBody
            }
        )
    }
}

struct FeedError_Previews: PreviewProvider {
    static var previews: some View {
        FeedError(error: .network)
    }
}
