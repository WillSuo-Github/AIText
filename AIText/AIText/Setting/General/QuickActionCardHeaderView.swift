//
//  HeaderView.swift
//  AIText
//
//  Created by will Suo on 2025/5/5.
//

import SwiftUI

struct QuickActionCardHeaderView: View {
    @Binding var quickItem: QuickItem
    var onDelete: () -> Void
    
    var body: some View {
        HStack {
            TextField(text: $quickItem.title) {
                EmptyView()
            }
            .font(.headline)
            .textFieldStyle(.plain)
            .padding(.vertical, 4)
            
            Spacer()
            
            Button {
                onDelete()
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.gray)
                    .imageScale(.medium)
            }
            .buttonStyle(.plain)
            .contentShape(Rectangle())
        }
        .padding(.horizontal, 12)
    }
}
