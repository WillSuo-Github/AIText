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

final class QuickActionManager: NSObject {
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
        print("refresh hotkeys")
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
            print("register hotkey, identifier: \(item.id.uuidString)")
        }
    }
}

// MARK: - Hotkey Action
extension QuickActionManager {
    @MainActor
    @objc func hotkeyCalled(_ hotKey: HotKey) {
        let identifier = hotKey.identifier
        guard let uuid = UUID(uuidString: identifier) else {
            print("hotkey called and identifier is invalid, identifier: \(identifier)")
            return
        }
        let descriptor = FetchDescriptor<QuickItem>(predicate: #Predicate { $0.id == uuid })
        guard let quickItem = try? sharedModelContainer.mainContext.fetch(descriptor).first else {
            print("hotkey called and there is no quick item in local, identifier: \(identifier)")
            return
        }
        
        Task {
            await AIAgency.shared.run(quickItem: quickItem)
        }
    }
}

extension Notification.Name {
    static let keyComboChanged = Notification.Name("keyComboChanged")
}


//
extension QuickActionManager: RecordViewDelegate {
    func recordViewShouldBeginRecording(_ recordView: KeyHolder.RecordView) -> Bool {
        return true
    }
    
    func recordView(_ recordView: KeyHolder.RecordView, canRecordKeyCombo keyCombo: Magnet.KeyCombo) -> Bool {
        return true
    }
    
    func recordView(_ recordView: KeyHolder.RecordView, didChangeKeyCombo keyCombo: Magnet.KeyCombo?) {
        print("key combo changed")
    }
    
    func recordViewDidEndRecording(_ recordView: KeyHolder.RecordView) {
        print("end recording")
    }
}
