//
//  QuickActionCardShortcutView.swift
//  AIText
//
//  Created by will Suo on 2025/5/5.
//

import SwiftUI
import Magnet

struct QuickActionCardShortcutView: View {
    @Binding var keyComboData: Data?
    var keyCombo: KeyCombo?
    var onClear: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(alignment: .center) {
            Text("Shortcut")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            // Placeholder for RecordViewWrapper
            RecordViewWrapper(keyComboData: $keyComboData)
                .frame(height: 34)
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
                    if keyCombo != nil {
                        Button {
                            onClear()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                        .buttonStyle(.plain)
                    }
                }
        }
    }
}
