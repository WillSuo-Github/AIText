//
//  MouseLoadingWindowController.swift
//  AIText
//
//  Created by will Suo on 2025/3/25.
//

import Cocoa

class MouseLoadingWindowController: NSWindowController {
    private lazy var animationViewController = AnimationViewController()
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.level = .screenSaver
        window?.backgroundColor = .clear
        window?.contentViewController = animationViewController
    }
}
