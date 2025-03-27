//
//  Version.swift
//  AIText
//
//  Created by will Suo on 2025/3/27.
//


import Foundation

final class Version {
    static func currentVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        return "\(version ?? "Unknown") (\(build ?? "Unknown"))"
    }
}
