//
//  AIService.swift
//  AIText
//
//  Created by will Suo on 2025/3/25.
//

import Foundation

enum AIService: String, CaseIterable {
    case openAI
    
    func displayName() -> String {
        switch self {
        case .openAI: return "OpenAI"
        }
    }
    
    func placeholder() -> String {
        switch self {
        case .openAI: return "SK-*************************************************"
        }
    }
    
    func apiKey() -> String {
        return APIKeyManager.shared.getAPIKey(service: self) ?? ""
    }
}
