//
//  QuickActionCardView.swift
//  AIText
//
//  Created by will Suo on 2025/3/24.
//

import Foundation
import SwiftUI

struct QuickActionCardView: View {
    @State var quickItem: QuickItem
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                TextField(text: $quickItem.title) {
                    EmptyView()
                }
                .font(.headline)
                .textFieldStyle(.plain)
                .padding(.vertical, 4)
                
                Spacer()
                
                Button {
                    delete()
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.gray)
                        .imageScale(.medium)
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
            }
            .padding(.horizontal, 12)
            
            HStack(alignment: .center) {
                Text("Shortcut")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                RecordViewWrapper(keyComboData: $quickItem.keyComboData)
                    .frame(width: 200, height: 34)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(colorScheme == .dark ? Color.black.opacity(0.2) : Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .overlay(alignment: .trailing) {
                        if quickItem.keyCombo != nil {
                            Button {
                                clearShortcut()
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Prompt")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $quickItem.prompt)
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
                    
                    if quickItem.prompt.isEmpty {
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
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal, 4)
        .padding(.vertical, 8)
    }
    
    private func clearShortcut() {
        quickItem.keyCombo = nil
    }
    
    private func delete() {
        withAnimation {
            sharedModelContainer.mainContext.delete(quickItem)
            try? sharedModelContainer.mainContext.save()
        }
    }
}

#Preview {
    QuickActionCardView(quickItem: QuickItem(title: "Test", prompt: ""))
}



