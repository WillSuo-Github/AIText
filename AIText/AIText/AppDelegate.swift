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
        
        menu.addItem(NSMenuItem.separator()) // separator
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))
        
        return menu
    }()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("✅ AppDelegate started successfully")

        QuickActionManager.shared.start()
        MouseLoadingManager.shared.start()
        ContextMenuManager.shared.start()
        AITextContextService.shared.registerServices()
        
        // Create menu bar icon
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.title = ""
            let hostingView = MenuBarView()
            button.addSubview(hostingView)
            hostingView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.height.equalTo(18)
                make.width.equalTo(30)
            }
            hostingView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        
        // Configure menu
        statusItem?.menu = menu
    }
    
}

extension AppDelegate: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        // Actions when menu opens
        print("Menu will open")
    }
    
    func menuDidClose(_ menu: NSMenu) {
        // Actions when menu closes
        print("Menu closed")
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
        print("Window activated")
    }
    
    func windowDidResignKey(_ notification: Notification) {
        print("The window has lost focus.")
    }
}
