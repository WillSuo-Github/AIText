//
//  AboutSettingView.swift
//  AIText
//
//  Created by will Suo on 2025/3/24.
//

import Foundation
import SwiftUI

struct AboutSettingView: View {
    var body: some View {
        List {
            VStack {
                HStack {
                    Text("About")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                GroupBox {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Version.currentVersion())
                    }
                    .frame(height: 30)
                    Divider()
                    HStack {
                        Text("Feedback")
                        Spacer()
                        Link(
                            "Send Email",
                            destination: URL(
                                string: "mailto:ws.feedback@outlook.com")!)
                    }
                    .frame(height: 30)
                }
                
                Spacer().frame(height: 20)
                
                HStack {
                    Text("Privacy Policy")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                GroupBox {
                    HStack {
                        Link(
                            "Terms and Conditions",
                            destination: URL(
                                string:
                                    "https://www.apple.com/legal/internet-services/itunes/dev/stdeula"
                            )!)
                        Spacer()
                    }
                    .frame(height: 30)
                    
                    Divider()
                    
                    HStack {
                        Link(
                            "Privacy Policy",
                            destination: URL(
                                string:
                                    "https://dogs-shop-x7k.craft.me/6lRbibEoOF161a"
                            )!)
                        Spacer()
                    }
                    .frame(height: 30)
                }
            }
        }
    }
}

#Preview {
    AboutSettingView()
}
