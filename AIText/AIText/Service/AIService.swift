//
//  AIService.swift
//  AIText
//
//  Created by will Suo on 2025/3/25.
//

import Foundation
import OpenAI
import GoogleGenerativeAI

enum AIService: String, CaseIterable {
    case openAI
    case gemini
    case deepSeek
    
    func displayName() -> String {
        switch self {
        case .openAI: return "OpenAI"
        case .gemini: return "Gemini"
        case .deepSeek: return "DeepSeek"
        }
    }
    
    func placeholder() -> String {
        switch self {
        case .openAI: return "SK-*************************************************"
        case .gemini: return "*************************************************"
        case .deepSeek: return "************************************************"
        }
    }
    
    func apiKey() -> String? {
        return APIKeyManager.shared.getAPIKey(service: self)
    }
    
    func run(quickItem: QuickItem, selectionText: String) async throws -> String {
        guard let apiKey = apiKey() else {
            throw NSError(domain: displayName(), code: 0, userInfo: [NSLocalizedDescriptionKey: "No api key"])
        }
        
        print("get user selection text: \(selectionText)")
        
        switch self {
        case .openAI: return try await openAIRun(quickItem: quickItem, selectionText: selectionText, apiKey: apiKey)
        case .gemini: return try await geminiRun(quickItem: quickItem, selectionText: selectionText, apiKey: apiKey)
        case .deepSeek: return try await deepSeekRun(quickItem: quickItem, selectionText: selectionText, apiKey: apiKey)
        }
    }
}

// MARK: - OpenAI
extension AIService {
    func openAIRun(quickItem: QuickItem, selectionText: String, apiKey: String) async throws -> String {
        let prompt = quickItem.prompt

        
        let openAI = OpenAI(apiToken: apiKey)
        let query = ChatQuery(messages: [
            .system(.init(content: prompt)),
            .user(.init(content: .string(selectionText)))
        ], model: .gpt3_5Turbo, n: 1)
        
        let chatResult: ChatResult = try await openAI.chats(query: query)
        
        guard let result = chatResult.choices.first?.message.content?.string else {
            throw NSError(domain: "OpenAIService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No result"])
        }
        
        print("get openai result: \(result)")
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - Gemini
extension AIService {
    func geminiRun(quickItem: QuickItem, selectionText: String, apiKey: String) async throws -> String {
        let prompt = quickItem.prompt
        
        let model = GenerativeModel(name: "gemini-1.5-flash-latest", apiKey: apiKey)
        let chatResult = try await model.generateContent([prompt, selectionText])
        
        guard let result = chatResult.text else {
            throw NSError(domain: "GeminiService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No result"])
        }
        
        print("get gemini result: \(result)")
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - DeepSeek
extension AIService {
    func deepSeekRun(quickItem: QuickItem, selectionText: String, apiKey: String) async throws -> String {
        let prompt = quickItem.prompt

        let configration = OpenAI.Configuration(token: apiKey, host: "api.deepseek.com")
        let openAI = OpenAI(configuration: configration)
        let query = ChatQuery(messages: [
            .system(.init(content: prompt)),
            .user(.init(content: .string(selectionText)))
        ], model: "deepseek-chat", n: 1)
        
        let chatResult: ChatResult = try await openAI.chats(query: query)
        
        guard let result = chatResult.choices.first?.message.content?.string else {
            throw NSError(domain: "DeepSeekService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No result"])
        }
        
        print("get openai result: \(result)")
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}	
