//
//  File.swift
//  AIText
//
//  Created by will Suo on 2025/3/25.
//

import Foundation
import SwiftUI

final class AIAgency {
    static let shared = AIAgency()
    
    @AppStorage("SelectedAiService")
    var selectedAIService: AIService?
    
    func run(quickItem: QuickItem, selectionText: String) async -> String {
        guard let selectedAIService = selectedAIService else {
            return ""
        }
        
        NotificationCenter.default.post(name: .QuickActionStart, object: nil)
        
        guard quickItem.prompt.isEmpty == false else {
            NotificationCenter.default.post(name: .QuickActionError, object: nil)
            return ""
        }
        
        do {
            let result = try await selectedAIService.run(quickItem: quickItem, selectionText: selectionText)
            NotificationCenter.default.post(name: .QuickActionSuccess, object: nil)
            return result
        } catch {
            print("ai service error: \(error)")
            NotificationCenter.default.post(name: .QuickActionError, object: nil)
            return ""
        }
    }
}


// MARK: - Notify
extension Notification.Name {
    static let QuickActionStart = Notification.Name("QuickActionStart")
    static let QuickActionSuccess = Notification.Name("QuickActionSuccess")
    static let QuickActionError = Notification.Name("QuickActionError")
}
