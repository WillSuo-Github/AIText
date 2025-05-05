//
//  GeneralSettingView.swift
//  AIText
//
//  Created by will Suo on 2025/3/24.
//

import Foundation
import SwiftUI

struct GeneralSettingView: View {
    @State var selectedAIService: AIService? = AIAgency.shared.selectedAIService
    
    var body: some View {
        ScrollView {
            Section {
                GroupBox {                
                    ForEach(AIService.allCases, id: \.self) { service in
                        ServiceCardView(aiService: service, selectedAIService: $selectedAIService, apiKey: service.apiKey() ?? "")
                    }
                }
            } header: {
                HStack {
                    Text("Service")
                    Spacer()
                }
            }
        }
        .onChange(of: selectedAIService, { oldValue, newValue in
            AIAgency.shared.selectedAIService = newValue
        })
        .padding()
    }
}

#Preview {
    GeneralSettingView()
}



