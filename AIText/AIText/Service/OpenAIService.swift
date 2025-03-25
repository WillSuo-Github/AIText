//
//  OpenAIService.swift
//  AIText
//
//  Created by will Suo on 2025/3/25.
//

import Foundation
import OpenAI

final class OpenAIService {
    func run(quickItem: QuickItem) async throws -> String {
        let prompt = quickItem.prompt
        guard let openAIKey = APIKeyManager.shared.getAPIKey(service: .openAI) else {
            throw NSError(domain: "OpenAIService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No OpenAI key"])
        }
        
        let openAI = OpenAI(apiToken: openAIKey)
        let query = ChatQuery(messages: [
            .system(.init(content: prompt)),
            .user(.init(content: .string("")))
        ], model: .gpt4_o, n: 1)
        
        let chatResult: ChatResult = try await openAI.chats(query: query)
        
        guard let result = chatResult.choices.first?.message.content else {
            throw NSError(domain: "OpenAIService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No result"])
        }
        return result
    }
}
