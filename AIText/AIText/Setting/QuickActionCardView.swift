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
    
    var body: some View {
        VStack {
            HStack {
                TextField(text: $quickItem.title) {
                    EmptyView()
                }
                .textFieldStyle(.plain)
                .fixedSize()
                
                Spacer()
                
                Button {
                    delete()
                } label: {
                    Image(systemName: "trash")
                }
            }
            .padding(.horizontal, 8)
            .frame(height: 22)
            
            GroupBox {
                VStack {
                    HStack(alignment: .center) {
                        Text("Shortcut")
                        Spacer()
                        RecordViewWrapper(keyComboData: $quickItem.keyComboData)
                            .frame(width: 200, height: 30)
                            .overlay(alignment: .trailing) {
                                HStack {
                                    Button {
                                        clearShortcut()
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                    .buttonStyle(.plain)
                                    
                                    Spacer().frame(width: 8)
                                }
                                .opacity(quickItem.keyCombo != nil ? 1 : 0)
                            }
                    }
                    .frame(height: 30)
                    
                    Divider()
                    
                    HStack(alignment: .top) {
                        Text("Prompt")
                        Spacer().frame(width: 8)
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $quickItem.prompt)
                                .frame(height: 100)
                                .padding(4)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.1), lineWidth: 1) // 圆角边框
                                )
                            
                            if quickItem.prompt.isEmpty {
                                Text(String(localized: "Enter your prompt here..."))
                                    .foregroundColor(.gray)
                                    .padding(.top, 2)
                                    .padding(.horizontal, 8)
                                    .allowsHitTesting(false)
                            }
                        }
                    }
                }
                .padding(4)
            }
        }
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



