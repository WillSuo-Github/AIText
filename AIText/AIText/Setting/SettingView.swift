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
                Text("请选择一个设置项")
            }
        }
        .toolbar(.hidden, for: .automatic)
    }
}

enum MenuItem: String, CaseIterable, Identifiable {
    case general = "General"
    case about = "About"

    var id: String { self.rawValue }

    @ViewBuilder
    var view: some View {
        switch self {
        case .general:
            GeneralSettingView()
        case .about:
            AboutSettingView()
        }
    }
}

#Preview {
    SettingView()
}
