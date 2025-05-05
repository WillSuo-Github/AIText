//
//  SelectionManager.swift
//  AIText
//
//  Created by will Suo on 2025/3/25.
//

import Foundation
import ApplicationServices
import Cocoa

final class SelectionManager {
    static let shared = SelectionManager()
    
    private init() {}

    func getSelectedText() -> String? {
        // Clear clipboard to prevent reading old data
        let clipboard = NSPasteboard.general
        clipboard.clearContents()

        // Send Cmd + C to copy selected text
        let src = CGEventSource(stateID: .privateState)
        let cmdDown = CGEvent(keyboardEventSource: src, virtualKey: 0x38, keyDown: true) // Cmd press
        let cmdUp = CGEvent(keyboardEventSource: src, virtualKey: 0x38, keyDown: false) // Cmd release
        let cDown = CGEvent(keyboardEventSource: src, virtualKey: 0x08, keyDown: true) // C press
        let cUp = CGEvent(keyboardEventSource: src, virtualKey: 0x08, keyDown: false) // C release
        
        cmdDown?.flags = .maskCommand
        cDown?.flags = .maskCommand

        cmdDown?.post(tap: .cghidEventTap)
        cDown?.post(tap: .cghidEventTap)
        cUp?.post(tap: .cghidEventTap)
        cmdUp?.post(tap: .cghidEventTap)

        // Wait for clipboard update (slight delay)
        usleep(100_000) // 100ms

        // Get clipboard content
        let selectedText = clipboard.string(forType: .string)

        // If clipboard is still empty, return nil
        return selectedText?.isEmpty == false ? selectedText : nil
    }
}
