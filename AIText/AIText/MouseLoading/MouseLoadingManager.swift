//
//  MouseLoadingManager.swift
//  AIText
//
//  Created by will Suo on 2025/3/25.
//

import Cocoa

class MouseLoadingManager: NSObject {
    static let shared = MouseLoadingManager()
    
    private let mouseLoadingWindowController = MouseLoadingWindowController(windowNibName: "MouseLoadingWindowController")
    
    func start() {
        addObserver()
    }
    
    private func startLoading() {
        if let screen = NSScreen.main {
            let initialPosition = NSEvent.mouseLocation
            mouseLoadingWindowController.window?.setFrameOrigin(initialPosition)
            mouseLoadingWindowController.showWindow(nil)
            
            NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { event in
                var location = NSEvent.mouseLocation
                location.x += 10
                DispatchQueue.main.async {
                    self.mouseLoadingWindowController.window?.setFrameOrigin(location)
                }
            }

            NSEvent.addLocalMonitorForEvents(matching: .mouseMoved) { event in
                var location = NSEvent.mouseLocation
                location.x += 10
                DispatchQueue.main.async {
                    self.mouseLoadingWindowController.window?.setFrameOrigin(location)
                }
                return event
            }
        }
    }
    
    private func stopLoading() {
        mouseLoadingWindowController.close()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleQuickActionStart), name: .QuickActionStart, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleQuickActionEnd), name: .QuickActionSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleQuickActionEnd), name: .QuickActionError, object: nil)
    }
    
    @objc private func handleQuickActionStart() {
        DispatchQueue.main.async {
            self.startLoading()
        }
    }
    
    @objc private func handleQuickActionEnd() {
        DispatchQueue.main.async {
            self.stopLoading()
        }
    }
}
