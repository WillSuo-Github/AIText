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
import AppKit

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
    
    func executeQuickItemAction(_ item: QuickItem, selectionText: String) {
        Task {
            let result = await AIAgency.shared.run(quickItem: item, selectionText: selectionText)
            guard result.isEmpty == false else { return }
            
            // Copy result to clipboard
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(result, forType: .string)

            // Simulate Cmd+V paste operation
            let eventSource = CGEventSource(stateID: .privateState)
            let cmdDown = CGEvent(keyboardEventSource: eventSource, virtualKey: 0x38, keyDown: true) // Cmd press
            let vDown = CGEvent(keyboardEventSource: eventSource, virtualKey: 0x09, keyDown: true) // V press
            let vUp = CGEvent(keyboardEventSource: eventSource, virtualKey: 0x09, keyDown: false) // V release
            let cmdUp = CGEvent(keyboardEventSource: eventSource, virtualKey: 0x38, keyDown: false) // Cmd release

            cmdDown?.flags = .maskCommand
            vDown?.flags = .maskCommand

            cmdDown?.post(tap: .cghidEventTap)
            vDown?.post(tap: .cghidEventTap)
            vUp?.post(tap: .cghidEventTap)
            cmdUp?.post(tap: .cghidEventTap)
        }
    }
}

// MARK: - Hotkey Action
extension QuickActionManager {
    @MainActor
    @objc func hotkeyCalled(_ hotKey: HotKey) {
        print("Hotkey called, identifier: \(hotKey.identifier)")
        executeHotkeyAction(hotKey)
    }
    
    @MainActor
    private func executeHotkeyAction(_ hotKey: HotKey) {
        print("Executing last hotkey call, : \(hotKey.identifier)")

        let identifier = hotKey.identifier
        guard let uuid = UUID(uuidString: identifier) else {
            print("Invalid identifier: \(identifier)")
            return
        }
        
        let descriptor = FetchDescriptor<QuickItem>(predicate: #Predicate { $0.id == uuid })
        guard let quickItem = try? sharedModelContainer.mainContext.fetch(descriptor).first else {
            print("No quick item found, identifier: \(identifier)")
            return
        }

        guard let selectionText = SelectionManager.shared.getSelectedText(), !selectionText.isEmpty else {
            print("No selected text")
            return
        }

        executeQuickItemAction(quickItem, selectionText: selectionText)
    }
}

extension Notification.Name {
    static let keyComboChanged = Notification.Name("keyComboChanged")
}

// MARK: - RecordViewDelegate
extension QuickActionManager: RecordViewDelegate {
    func recordViewShouldBeginRecording(_ recordView: KeyHolder.RecordView) -> Bool {
        return true
    }
    
    func recordView(_ recordView: KeyHolder.RecordView, canRecordKeyCombo keyCombo: Magnet.KeyCombo) -> Bool {
        return true
    }
    
    func recordView(_ recordView: KeyHolder.RecordView, didChangeKeyCombo keyCombo: Magnet.KeyCombo?) {
        DispatchQueue.main.async {
            self.refreshHotkeys()
        }
    }
    
    func recordViewDidEndRecording(_ recordView: KeyHolder.RecordView) {
        print("end recording")
    }
}
