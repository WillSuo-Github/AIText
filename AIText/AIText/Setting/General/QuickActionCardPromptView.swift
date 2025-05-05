//
//  PromptView.swift
//  AIText
//
//  Created by will Suo on 2025/5/5.
//

import SwiftUI

struct QuickActionCardPromptView: View {
    @Binding var prompt: String
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Prompt")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $prompt)
                    .frame(minHeight: 120)
                    .padding(8)
                    .scrollContentBackground(.hidden)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(colorScheme == .dark ? Color.black.opacity(0.2) : Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                
                if prompt.isEmpty {
                    Text(String(localized: "Enter your prompt here..."))
                        .font(.body)
                        .foregroundColor(.gray.opacity(0.6))
                        .padding(.top, 8)
                        .padding(.leading, 12)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}
