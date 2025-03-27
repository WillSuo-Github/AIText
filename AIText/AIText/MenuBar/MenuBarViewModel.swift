//
//  MenuBarViewModel.swift
//  AIText
//
//  Created by will Suo on 2025/3/27.
//

import Foundation
import SwiftUI

@Observable
final class MenuBarViewModel {
    var imageStatus: ImageStatus = .normal
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(normal), name: .QuickActionSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loading), name: .QuickActionStart, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(error), name: .QuickActionError, object: nil)
    }
    
    @objc private func normal() {
        imageStatus = .normal
    }
    
    @objc private func loading() {
        imageStatus = .loading
    }
    
    @objc private func error() {
        imageStatus = .error
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.imageStatus = .normal
        }
    }

}
