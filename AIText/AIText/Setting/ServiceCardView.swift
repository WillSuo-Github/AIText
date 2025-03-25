//
//  ServiceCardView.swift
//  AIText
//
//  Created by will Suo on 2025/3/25.
//

import Foundation
import SwiftUI

struct ServiceCardView: View {
    @State var aiService: AIService
    @Binding var selectedAIService: AIService?
    @State var apiKey: String
    
    var body: some View {
        VStack {
            HStack {
                Toggle(isOn: Binding(
                    get: { selectedAIService == aiService },
                    set: { newValue in
                        selectedAIService = newValue ? aiService : nil
                    })) {
                    Text(aiService.displayName())
                }
                .toggleStyle(.checkbox)
                
                Spacer()
                
                TextField(aiService.placeholder(), text: $apiKey)
                    .frame(width: 300)
                    .background(Color.clear)
                    .onChange(of: apiKey) { oldValue, newValue in
                        APIKeyManager.shared.saveAPIKey(service: aiService, key: newValue)
                    }
            }
        }
    }
}
