//
//  AppDelegate.swift
//  AIText
//
//  Created by will Suo on 2025/3/23.
//

import Foundation
import SwiftUI
import SnapKit
import KeyHolder
import Magnet

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    
    private lazy var settingsWindow: NSWindow = {
        let result = NSWindow(
            contentRect: .init(origin: .zero, size: CGSize(width: 480, height: 300)),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        result.delegate = self
        result.contentView = NSHostingView(rootView: SettingView().modelContainer(sharedModelContainer))
        result.isReleasedWhenClosed = false
        return result
    }()
    
    private var popWindowController: PopWindowController?
    
    private lazy var menu: NSMenu = {
        let menu = NSMenu()
        menu.delegate = self
        
        let preferencesItem = NSMenuItem(title: "Preferences...", action: #selector(openPreferences), keyEquivalent: ",")
        preferencesItem.target = self
        menu.addItem(preferencesItem)
        
        menu.addItem(NSMenuItem.separator()) // 分隔符
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))
        
        return menu
    }()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("✅ AppDelegate 启动成功")

        QuickActionManager.shared.start()
        MouseLoadingManager.shared.start()
        
        // 创建菜单栏图标
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.title = ""
            let hostingView = NSHostingView(rootView: MenuBarView())
            button.addSubview(hostingView)
            hostingView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.height.equalTo(18)
                make.width.equalTo(30)
            }
            hostingView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        
        // 配置菜单
        statusItem?.menu = menu
    }
    
}

extension AppDelegate: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        // 在菜单打开时执行的操作
        print("菜单将要打开")
    }
    
    func menuDidClose(_ menu: NSMenu) {
        // 在菜单关闭时执行的操作
        print("菜单已关闭")
    }
}

// MARK: - Actions
extension AppDelegate {
    @objc func openPreferences() {
        settingsWindow.setFrame(NSRect(x: 0, y: 0, width: 800, height: 600), display: true)
        NSApp.runModal(for: settingsWindow)
        settingsWindow.center()
    }
    
    @objc func quitApp() {
        NSApp.terminate(nil)
    }
}

// MARK: - NSWindowDelegate
extension AppDelegate: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        NSApp.stopModal()
    }
    
    func windowDidBecomeKey(_ notification: Notification) {
        print("窗口已激活")
    }
    
    func windowDidResignKey(_ notification: Notification) {
        print("The window has lost focus.")
    }
}
