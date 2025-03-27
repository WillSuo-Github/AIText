//
//  MenuBarView.swift
//  AIText
//
//  Created by will Suo on 2025/3/27.
//

import Foundation
import SwiftUI

enum ImageStatus {
    case normal
    case loading
    case error
}

struct MenuBarView: View {
    @State private var viewModel = MenuBarViewModel()
    
    var body: some View {
        VStack {
            switch viewModel.imageStatus {
            case .normal:
                Image(.logo)
                    .resizable()
                    .scaledToFit()
            case .error:
                Image(systemName: "exclamationmark.triangle.fill")
            case .loading:
                ProgressView()
                    .controlSize(.small)
                    .springLoadingBehavior(.enabled)
            }
        }
    }
}
