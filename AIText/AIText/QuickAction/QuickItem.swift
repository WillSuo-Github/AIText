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
        }
    }
    
    init(title: String, prompt: String) {
        self.title = title
        self.prompt = prompt
    }
}

extension QuickItem {
    static func getKeyCombo(_ keyComboData: Data?) -> KeyCombo? {
        guard let keyComboData = keyComboData else { return nil }
        return try? JSONDecoder().decode(KeyCombo.self, from: keyComboData)
    }
}
