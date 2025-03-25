//
//  SettingCardView.swift
//  AIText
//
//  Created by will Suo on 2025/3/24.
//

import Foundation
import SwiftUI
import KeyboardShortcuts

struct SettingCardView: View {
    @State var quickItem: QuickItem
    
    var body: some View {
        VStack {
            HStack {
                Text("Title")
                Spacer()
                TextField(text: $quickItem.title) {
                    EmptyView()
                }
            }
            HStack {
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
            HStack {
                Text("Prompt")
                Spacer()
                Text(quickItem.prompt)
                    .font(.subheadline)
            }
        }
    }
    
    private func clearShortcut() {
        quickItem.keyCombo = nil
    }
}

#Preview {
    SettingCardView(quickItem: QuickItem(title: "Test", prompt: "Test prompt"))
}



