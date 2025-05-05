//
//  QuickAction.swift
//  AIText
//
//  Created by will Suo on 2025/3/24.
//

import Foundation
import SwiftUI
import SwiftData

struct QuickActionSettingView: View {
    @Query(filter: #Predicate<QuickItem> { _ in true }, sort: \QuickItem.createTime, order: .forward)
    var quickItems: [QuickItem]

    var body: some View {
        List {
            if quickItems.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "star.square.on.square")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("No Quick Actions Yet")
                        .font(.headline)
                    
                    Text("Create your first quick action to enhance your workflow")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .listRowSeparator(.hidden)
            } else {
                ForEach(quickItems) { quickItem in
                    QuickActionCardView(quickItem: quickItem)
                        .listRowSeparator(.hidden)
                }
            }
            
            HStack(alignment: .center) {
                Spacer()
                Button {
                    addQuickItem()
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Create Quick Action")
                    }
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .buttonStyle(.plain)
                Spacer()
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    private func addQuickItem() {
        let quickItem = QuickItem(title: String(localized: "New Quick Action"), prompt: "")
        sharedModelContainer.mainContext.insert(quickItem)
        try? sharedModelContainer.mainContext.save()
    }
}

#Preview {
    QuickActionSettingView()
}
