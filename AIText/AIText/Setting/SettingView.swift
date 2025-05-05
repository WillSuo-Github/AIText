//
//  SettingView.swift
//  AIText
//
//  Created by will Suo on 2025/3/23.
//

import SwiftUI

struct SettingView: View {
    @State private var selectedMenu: MenuItem? = .general

    var body: some View {
        NavigationSplitView {
            List(MenuItem.allCases, selection: $selectedMenu) { item in
                Text(item.rawValue)
                    .tag(item)
            }
        } detail: {
            if let selectedMenu = selectedMenu {
                selectedMenu.view
            } else {
                Text("Please select a menu item")
            }
        }
        .toolbar(.hidden, for: .automatic)
        .frame(minWidth: 500, minHeight: 400)
    }
}

enum MenuItem: String, CaseIterable, Identifiable {
    case general = "General"
    case quickAction = "Quick Action"
    case about = "About"

    var id: String { self.rawValue }

    @ViewBuilder
    var view: some View {
        switch self {
        case .general:
            GeneralSettingView()
        case .about:
            AboutSettingView()
        case .quickAction:
            QuickActionSettingView()
        }
    }
}

#Preview {
    SettingView()
}
