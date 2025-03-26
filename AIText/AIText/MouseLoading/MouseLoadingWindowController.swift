//
//  MouseLoadingWindowController.swift
//  AIText
//
//  Created by will Suo on 2025/3/25.
//

import Cocoa

class MouseLoadingWindowController: NSWindowController {
    private lazy var animationViewController = AnimationViewController()
    private lazy var errorViewController = ErrorViewController(nibName: "ErrorViewController", bundle: nil)
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.level = .screenSaver
        window?.backgroundColor = .clear
        window?.contentViewController = animationViewController
        addObserver()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleStart), name: .QuickActionStart, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleError), name: .QuickActionError, object: nil)
    }
    
    @objc private func handleError() {
        DispatchQueue.main.async {
            self.window?.contentViewController = self.errorViewController
        }
    }
    
    @objc private func handleStart() {
        DispatchQueue.main.async {
            self.window?.contentViewController = self.animationViewController
        }
    }
}
