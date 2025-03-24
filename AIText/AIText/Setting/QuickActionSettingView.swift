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
            ForEach(quickItems) { quickItem in
                SettingCardView(quickItem: quickItem)
            }
            
            Button {
                addQuickItem()
            } label: {
                Text("Add")
            }
        }
    }
    
    private func addQuickItem() {
        let quickItem = QuickItem(title: "Test", prompt: "Test prompt")
        sharedModelContainer.mainContext.insert(quickItem)
        try? sharedModelContainer.mainContext.save()
    }
}
