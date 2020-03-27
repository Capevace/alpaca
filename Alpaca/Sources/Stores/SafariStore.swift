//
//  SafariStore.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 22.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

import SwiftUI
import SafariServices

/// The store handling the SFSafariViewController state.
class SafariStore: NSObject, ObservableObject, SFSafariViewControllerDelegate {
    
    let url: URL
    
    /// The SFSafariViewController instance that will be rendered in the view.
    @Published var safariViewController: SFSafariViewController? = nil
    
    @Published var ready: Bool = false
    
    /// Called when "Done" button in SFSafariViewController is pressed.
    @Binding var articleViewDisplayed: Bool
  
    
    /// Initialize a new SafariStore instance
    /// - Parameters:
    ///   - url: The url to load in the SFSafariViewController.
    ///   - onDismiss: Called when "Done" button in SFSafariViewController is pressed.
    init(_ url: URL, articleViewDisplayed: Binding<Bool>) {
        self.url = url
        self._articleViewDisplayed = articleViewDisplayed
    }
    
    /// Setup SFSafariViewController observers to propagate state changes to SwiftUI
    private func setupObservers() {
        // We can only setup observers, if there's a SFSafariViewController set
        if safariViewController == nil {
            print("Don't call setupObservers unless there's a SFSafariViewController set in SafariStore")
            return
        }
        
        func subscriber<Value>(for keyPath: KeyPath<SFSafariViewController, Value>) -> NSKeyValueObservation {
            return safariViewController!.observe(keyPath, options: [.prior]) { _, change in
                if change.isPrior {
                    self.objectWillChange.send()
                }
            }
        }
    
        // Setup observers for all KVO compliant properties
        observers = [
            subscriber(for: \.title)
//      subscriber(for: \.),
//      subscriber(for: \.isLoading),
//      subscriber(for: \.estimatedProgress),
//      subscriber(for: \.hasOnlySecureContent),
//      subscriber(for: \.serverTrust),
//      subscriber(for: \.canGoBack),
//      subscriber(for: \.canGoForward)
        ]
    }
  
    /// SFSafariViewController state observers
    private var observers: [NSKeyValueObservation] = []
  
    deinit {
        observers.forEach {
            // Not even sure if this is required?
            // Probably wont be needed in future betas?
            $0.invalidate()
        }
    }
    
    func enable() {
        let vc = SFSafariViewController(url: url)
        vc.delegate = self
        vc.preferredBarTintColor = UIColor.articleBackground
        vc.preferredControlTintColor = UIColor.secondaryLabel
        
        self.safariViewController = vc
        
        // Setup SFSafariViewController observers to propagate state changes to SwiftUI
        setupObservers()
        
        self.ready = true
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.articleViewDisplayed = false
    }
    
    class func mocked() -> SafariStore {
        SafariStore(URL(string: "https://news.ycombinator.com")!, articleViewDisplayed: .constant(true))
    }
}
