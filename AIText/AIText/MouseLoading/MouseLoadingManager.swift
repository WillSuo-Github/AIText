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
        mouseLoadingWindowController.window?.setFrameOrigin(loadingPosition())
        mouseLoadingWindowController.showWindow(nil)
        
        NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved, .leftMouseDragged]) { event in
            DispatchQueue.main.async {
                self.mouseLoadingWindowController.window?.setFrameOrigin(self.loadingPosition())
            }
        }
    }
    
    private func loadingPosition() -> NSPoint {
        let initialPosition = NSEvent.mouseLocation
        var location = initialPosition
        location.x += 10
        location.y -= 35
        return location
    }
    
    private func stopLoadingWithSuccess() {
        mouseLoadingWindowController.close()
    }
    
    private func stopLoadingWithError() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.mouseLoadingWindowController.close()
        }
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleQuickActionStart), name: .QuickActionStart, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleQuickActionSuccess), name: .QuickActionSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handQuickActionError), name: .QuickActionError, object: nil)
    }
    
    @objc private func handleQuickActionStart() {
        DispatchQueue.main.async {
            self.startLoading()
        }
    }
    
    @objc private func handleQuickActionSuccess() {
        DispatchQueue.main.async {
            self.stopLoadingWithSuccess()
        }
    }
    
    @objc private func handQuickActionError() {
        DispatchQueue.main.async {
            self.stopLoadingWithError()
        }
    }
}
