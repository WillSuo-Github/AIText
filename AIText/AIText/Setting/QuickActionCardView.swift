//
//  QuickActionCardView.swift
//  AIText
//
//  Created by will Suo on 2025/3/24.
//

import Foundation
import SwiftUI
import KeyboardShortcuts

struct QuickActionCardView: View {
    @State var quickItem: QuickItem
    
    var body: some View {
        GroupBox {
            VStack {
                HStack {
                    TextField(text: $quickItem.title) {
                        EmptyView()
                    }
                    .textFieldStyle(.plain)
                    .fixedSize()
                    Spacer()
                }
                .frame(height: 30)
                
                Divider()
                
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
                    TextEditor(text: $quickItem.prompt)
                        .frame(height: 100)
                        .padding(4)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1) // 圆角边框
                        )
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private func clearShortcut() {
        quickItem.keyCombo = nil
    }
}

#Preview {
    QuickActionCardView(quickItem: QuickItem(title: "Test", prompt: "Test prompt"))
}



