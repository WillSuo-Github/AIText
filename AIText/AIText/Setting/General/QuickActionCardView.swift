//
//  QuickActionCardView.swift
//  AIText
//
//  Created by will Suo on 2025/3/24.
//

import Foundation
import SwiftUI
import Magnet

// MARK: - Main Card View
struct QuickActionCardView: View {
    @State var quickItem: QuickItem
    
    var body: some View {
        VStack {
            GroupBox {
                VStack(spacing: 8) {
                    QuickActionCardHeaderView(quickItem: $quickItem, onDelete: delete)
                    
                    Divider()
                    
                    QuickActionCardShortcutView(keyComboData: $quickItem.keyComboData,
                                 keyCombo: quickItem.keyCombo,
                                 onClear: clearShortcut)
                    
                    Divider()
                    
                    QuickActionCardPromptView(prompt: $quickItem.prompt)
                }
                .padding(4)
            }
            .padding(4)
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 8)
    }
    
    private func clearShortcut() {
        quickItem.keyCombo = nil
    }
    
    private func delete() {
        // Implement actual delete functionality when you have a model container
        print("Delete action triggered")
    }
}

#Preview {
    QuickActionCardView(quickItem: QuickItem(title: "Test", prompt: ""))
}



