//
//  QuickActionManager.swift
//  AIText
//
//  Created by will Suo on 2025/3/25.
//

import Foundation
import SwiftData
import KeyHolder
import Magnet

final class QuickActionManager {
    static let shared = QuickActionManager()
    
    @MainActor
    func start() {
        addObserver()
        refreshHotkeys()
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(forName: .keyComboChanged, object: nil, queue: .main) { _ in
            Task {
                await MainActor.run { [weak self] in
                    self?.refreshHotkeys()
                }
            }
        }
    }
    
    @MainActor
    func refreshHotkeys() {
        HotKeyCenter.shared.unregisterAll()
        
        let descriptor = FetchDescriptor<QuickItem>(
            predicate: #Predicate { $0.keyComboData != nil }
        )
        guard let quickItems = try? sharedModelContainer.mainContext.fetch(descriptor) else { return }
        
        for item in quickItems {
            guard let keyCombo = QuickItem.getKeyCombo(item.keyComboData) else { continue }
            let hotKey = HotKey(identifier: item.id.uuidString,
                                keyCombo: keyCombo,
                                target: self,
                                action: #selector(hotkeyCalled(_:)))
            hotKey.register()
        }
    }
}

// MARK: - Hotkey Action
extension QuickActionManager {
    @MainActor
    @objc func hotkeyCalled(_ hotKey: HotKey) {
        let identifier = hotKey.identifier
        let descriptor = FetchDescriptor<QuickItem>(predicate: #Predicate { $0.id.uuidString == identifier })
        guard let quickItem = try? sharedModelContainer.mainContext.fetch(descriptor) else {
            print("hotkey called and there is no quick item in local, identifier: \(identifier)")
            return
        }
        
        
    }
}

extension Notification.Name {
    static let keyComboChanged = Notification.Name("keyComboChanged")
}
