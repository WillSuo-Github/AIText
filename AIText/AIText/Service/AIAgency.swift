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
    
    func run(quickItem: QuickItem) async -> String {
        NotificationCenter.default.post(name: .QuickActionStart, object: nil)
        
        guard quickItem.prompt.isEmpty == false else {
            NotificationCenter.default.post(name: .QuickActionError, object: nil)
            return ""
        }
        
        do {
            let result = try await openAIService.run(quickItem: quickItem)
            NotificationCenter.default.post(name: .QuickActionSuccess, object: nil)
            return result
        } catch {
            print("Error: \(error)")
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
