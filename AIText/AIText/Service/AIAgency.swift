//
//  File.swift
//  AIText
//
//  Created by will Suo on 2025/3/25.
//

import Foundation

final class AIAgency {
    static let shared = AIAgency()
    
    private var openAIService = OpenAIService()
    
    func run(quickItem: QuickItem, selectionText: String) async -> String {
        NotificationCenter.default.post(name: .QuickActionStart, object: nil)
        
        guard quickItem.prompt.isEmpty == false else {
            NotificationCenter.default.post(name: .QuickActionError, object: nil)
            return ""
        }
        
        do {
            let result = try await openAIService.run(quickItem: quickItem, selectionText: selectionText)
            return result
        } catch {
            print("OpenAI service error: \(error)")
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
