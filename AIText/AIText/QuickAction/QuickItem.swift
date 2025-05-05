//
//  QuickItem.swift
//  AIText
//
//  Created by will Suo on 2025/3/24.
//

import Foundation
import SwiftData
import Magnet

@Model
class QuickItem: Identifiable {
    var id: UUID = UUID()
    var title: String
    var prompt: String
    var keyComboData: Data?
    var createTime: Date = Date()
    
    var keyCombo: Magnet.KeyCombo? {
        get {
            guard let data = keyComboData else { return nil }
            return try? JSONDecoder().decode(KeyCombo.self, from: data)
        }
        set {
            if newValue == nil {
                keyComboData = nil
            } else {
                keyComboData = try? JSONEncoder().encode(newValue)
            }
            // 发送通知
            postChangeNotification()
        }
    }
    
    init(title: String, prompt: String) {
        self.title = title
        self.prompt = prompt
        // 发送通知
        postChangeNotification()
    }
    
    func postChangeNotification() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .quickItemsChanged, object: nil)
        }
    }
}

extension QuickItem {
    static func getKeyCombo(_ keyComboData: Data?) -> KeyCombo? {
        guard let keyComboData = keyComboData else { return nil }
        return try? JSONDecoder().decode(KeyCombo.self, from: keyComboData)
    }
}

// 添加观察者API
extension QuickItem {
    static func addChangeObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(
            observer,
            selector: selector,
            name: .quickItemsChanged,
            object: nil
        )
    }
    
    static func removeChangeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(
            observer,
            name: .quickItemsChanged,
            object: nil
        )
    }
}
