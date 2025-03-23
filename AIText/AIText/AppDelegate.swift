//
//  AppDelegate.swift
//  AIText
//
//  Created by will Suo on 2025/3/23.
//

import Foundation
import SwiftUI
import SnapKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    
    private lazy var settingsWindow: NSWindow = {
        let result = NSWindow(
            contentRect: .init(origin: .zero, size: CGSize(width: 480, height: 300)),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        result.isReleasedWhenClosed = false
        return result
    }()
    
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
        //        NSApp.setActivationPolicy(.accessory)
        
        // 创建菜单栏图标
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.title = ""
            let hostingView = NSHostingView(rootView: Image(systemName: "globe"))
            button.addSubview(hostingView)
            hostingView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.height.equalTo(18)
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
        settingsWindow.contentView = NSHostingView(rootView: SettingView())
        settingsWindow.makeKeyAndOrderFront(nil)
        settingsWindow.center()
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func quitApp() {
        NSApp.terminate(nil)
    }
}
