//
//  AITextApp.swift
//  AIText
//
//  Created by will Suo on 2025/3/23.
//

import SwiftUI

@main
struct AITextApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            SettingView()
        }
    }
}
