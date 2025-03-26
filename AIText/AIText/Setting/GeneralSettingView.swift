//
//  GeneralSettingView.swift
//  AIText
//
//  Created by will Suo on 2025/3/24.
//

import Foundation
import SwiftUI

struct GeneralSettingView: View {
    var body: some View {
        List {
            Section {
                ForEach(AIService.allCases, id: \.self) { service in
                    ServiceCardView(aiService: service, selectedAIService: AIAgency.shared.$selectedAIService, apiKey: service.apiKey())
                }
            } header: {
                Text("")
            }
        }
    }
}

#Preview {
    GeneralSettingView()
}



