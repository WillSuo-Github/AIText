//
//  MouseLoadingWindowController.swift
//  AIText
//
//  Created by will Suo on 2025/3/25.
//

import Cocoa

class MouseLoadingWindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.level = .screenSaver
        window?.backgroundColor = .clear
    }
}
