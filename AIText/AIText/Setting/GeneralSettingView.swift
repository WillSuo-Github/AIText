//
//  GeneralSettingView.swift
//  AIText
//
//  Created by will Suo on 2025/3/24.
//

import Foundation
import SwiftUI

struct GeneralSettingView: View {
    @State private var selectedAIService: AIService?
    
    var body: some View {
        List {
            Section {
                ForEach(AIService.allCases, id: \.self) { service in
                    ServiceCardView(aiService: service, selectedAIService: $selectedAIService)
                }
            } header: {
                Text("Services")
            }
        }
    }
}

#Preview {
    GeneralSettingView()
}



