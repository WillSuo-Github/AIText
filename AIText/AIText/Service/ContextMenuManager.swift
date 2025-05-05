import Foundation
import SwiftData
import AppKit

class ContextMenuManager: NSObject {
    static let shared = ContextMenuManager()
    
    private var service: NSMenuItem?
    private var submenu: NSMenu?
    
    @MainActor
    func start() {
        registerService()
        refreshMenuItems()
        
        NotificationCenter.default.addObserver(
            forName: .quickItemsChanged,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.refreshMenuItems()
            }
    }
    
    @MainActor
    private func registerService() {
        let servicesProvider = NSApplication.shared
        
        self.submenu = NSMenu(title: "AIText")
        self.service = NSMenuItem(title: "AIText", action: nil, keyEquivalent: "")
        self.service?.submenu = submenu
        
        NSApp.servicesMenu?.addItem(self.service!)
    }
    
    @MainActor
    func refreshMenuItems() {
        guard let submenu = self.submenu else { return }
        
        submenu.removeAllItems()
        
        let descriptor = FetchDescriptor<QuickItem>()
        guard let quickItems = try? sharedModelContainer.mainContext.fetch(descriptor) else { return }
        
        for item in quickItems {
            let menuItem = NSMenuItem(
                title: item.title,
                action: #selector(handleContextMenuAction(_:)),
                keyEquivalent: ""
            )
            menuItem.target = self
            menuItem.representedObject = item.id.uuidString
            submenu.addItem(menuItem)
        }
    }
    
    @objc private func handleContextMenuAction(_ sender: NSMenuItem) {
        guard let identifier = sender.representedObject as? String,
              let uuid = UUID(uuidString: identifier) else { return }
        
        Task {
            await MainActor.run {
                executeMenuAction(uuid: uuid)
            }
        }
    }
    
    @MainActor
    private func executeMenuAction(uuid: UUID) {
        guard let selectionText = SelectionManager.shared.getSelectedText(), !selectionText.isEmpty else {
            print("No text selected")
            return
        }
        
        executeMenuItemAction(uuid: uuid, text: selectionText)
    }
    
    @MainActor
    func executeMenuItemAction(uuid: UUID, text: String) {
        let descriptor = FetchDescriptor<QuickItem>(predicate: #Predicate { $0.id == uuid })
        guard let quickItem = try? sharedModelContainer.mainContext.fetch(descriptor).first else { return }
        
        QuickActionManager.shared.executeQuickItemAction(quickItem, selectionText: text)
    }
}

// 添加通知名称
extension Notification.Name {
    static let quickItemsChanged = Notification.Name("quickItemsChanged")
} 
