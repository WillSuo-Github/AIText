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
        // 清空剪贴板，防止读取到旧数据
        let clipboard = NSPasteboard.general
        clipboard.clearContents()

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

        // 获取剪贴板内容
        let selectedText = clipboard.string(forType: .string)

        // 如果剪贴板仍然为空，则返回 nil
        return selectedText?.isEmpty == false ? selectedText : nil
    }
}
