//
//  PopWindowController.swift
//  AIText
//
//  Created by will Suo on 2025/3/30.
//

import Cocoa
import SwiftUI
import SnapKit

class PopWindowController: NSWindowController {
    @IBOutlet weak var effectView: NSVisualEffectView!
    
    private var selectionText: String
    
    init(selectionText: String) {
        self.selectionText = selectionText
        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("PopWindowController")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.contentView?.wantsLayer = true
        window?.contentView?.layer?.cornerRadius = 12
        window?.contentView?.layer?.masksToBounds = true
        window?.setFrame(NSRect(x: 0, y: 0, width: 300, height: 600), display: false)
        window?.level = .popUpMenu
        window?.backgroundColor = .clear
        window?.isMovableByWindowBackground = true
        
        let popContentView = NSHostingView(rootView: PopWindowContentView())
        effectView.addSubview(popContentView)
        popContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}



