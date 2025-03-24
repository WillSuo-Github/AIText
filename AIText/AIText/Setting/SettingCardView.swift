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
    var body: some View {
        VStack {
            HStack {
                Text("Shortcut")
                Spacer()
                KeyboardShortcuts.Recorder("", name: .toggleUnicornMode)
            }
        }
    }
}

#Preview {
    SettingCardView()
}

extension KeyboardShortcuts.Name {
    static let toggleUnicornMode = Self("toggleUnicornMode")
}
