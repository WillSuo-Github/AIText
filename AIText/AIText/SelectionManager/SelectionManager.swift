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
        // 发送 Cmd + C 复制选中文本
        let src = CGEventSource(stateID: .hidSystemState)
        let cmdDown = CGEvent(keyboardEventSource: src, virtualKey: 0x38, keyDown: true) // Cmd 按下
        let cmdUp = CGEvent(keyboardEventSource: src, virtualKey: 0x38, keyDown: false) // Cmd 松开
        let cDown = CGEvent(keyboardEventSource: src, virtualKey: 0x08, keyDown: true) // C 按下
        let cUp = CGEvent(keyboardEventSource: src, virtualKey: 0x08, keyDown: false) // C 松开
        
        cmdDown?.flags = .maskCommand
        cDown?.flags = .maskCommand

        cmdDown?.post(tap: .cghidEventTap)
        cDown?.post(tap: .cghidEventTap)
        cUp?.post(tap: .cghidEventTap)
        cmdUp?.post(tap: .cghidEventTap)

        // 等待剪贴板更新（稍作延迟）
        usleep(100_000) // 100ms

        // 从剪贴板读取文本
        let clipboard = NSPasteboard.general
        return clipboard.string(forType: .string)
    }
}
