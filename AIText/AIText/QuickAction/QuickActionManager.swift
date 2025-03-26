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
    private var lastWorkItem: DispatchWorkItem?
    
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
        print("Hotkey called, identifier: \(hotKey.identifier)")
        
        if let lastWorkItem = lastWorkItem {
            lastWorkItem.cancel()
        }
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.executeHotkeyAction(hotKey)
        }
        
        lastWorkItem = workItem
        if hotKey.keyCombo.doubledModifiers && hotKey.keyCombo.keyEquivalentModifierMask.contains(.command) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workItem)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: workItem)
        }
    }
    
    @MainActor
    private func executeHotkeyAction(_ hotKey: HotKey) {
        print("Executing last hotkey call, identifier: \(hotKey.identifier)")

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

        guard let selectionText = SelectionManager.shared.getSelectedText() else {
            print("No selected text")
            return
        }

        Task {
            let result = await AIAgency.shared.run(quickItem: quickItem, selectionText: selectionText)
            // 将结果复制到剪贴板
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(result, forType: .string)

            // 模拟 Cmd+V 粘贴操作
            let eventSource = CGEventSource(stateID: .hidSystemState)
            let cmdDown = CGEvent(keyboardEventSource: eventSource, virtualKey: 0x38, keyDown: true) // Cmd 按下
            let vDown = CGEvent(keyboardEventSource: eventSource, virtualKey: 0x09, keyDown: true) // V 按下
            let vUp = CGEvent(keyboardEventSource: eventSource, virtualKey: 0x09, keyDown: false) // V 松开
            let cmdUp = CGEvent(keyboardEventSource: eventSource, virtualKey: 0x38, keyDown: false) // Cmd 松开

            cmdDown?.flags = .maskCommand
            vDown?.flags = .maskCommand

            cmdDown?.post(tap: .cghidEventTap)
            vDown?.post(tap: .cghidEventTap)
            vUp?.post(tap: .cghidEventTap)
            cmdUp?.post(tap: .cghidEventTap)
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
