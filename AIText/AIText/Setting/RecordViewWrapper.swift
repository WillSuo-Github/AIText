//
//  RecordViewWrapper.swift
//  AIText
//
//  Created by will Suo on 2025/3/24.
//


import SwiftUI
import KeyHolder
import Magnet

struct RecordViewWrapper: NSViewRepresentable {
    @Binding var keyComboData: Data?
    
    func makeNSView(context: Context) -> RecordView {
        let result = RecordView()
        result.backgroundColor = .secondarySystemFill
        result.tintColor = NSColor.controlAccentColor
        result.cornerRadius = 8
        result.clearButtonMode = .never
        result.delegate = NSApplication.shared.delegate as? AppDelegate
        result.didChange = { keyCombo in
            guard let keyCombo = keyCombo else {
                return
            }
            self.keyComboData = try? JSONEncoder().encode(keyCombo)
        }
        let clickGesture = NSClickGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleClick(_:)))
        result.addGestureRecognizer(clickGesture)
        return result
    }

    func updateNSView(_ nsView: RecordView, context: Context) {
        print("record view update")
        let newKey = QuickItem.getKeyCombo(keyComboData)
        nsView.keyCombo = newKey
        if newKey == nil {
            nsView.clear()
        }
        nsView.layoutSubtreeIfNeeded()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
}

class Coordinator: NSObject {
    var parent: RecordViewWrapper

    init(parent: RecordViewWrapper) {
        self.parent = parent
    }

    @objc func handleClick(_ sender: NSClickGestureRecognizer) {
        if let recordView = sender.view as? RecordView {
            recordView.window?.makeFirstResponder(recordView)
        }
    }
}
