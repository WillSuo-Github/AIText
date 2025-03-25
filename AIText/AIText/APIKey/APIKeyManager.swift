//
//  APIKeyManager.swift
//  AIText
//
//  Created by will Suo on 2025/3/25.
//

import Foundation
import Security

final class APIKeyManager {
    static let shared = APIKeyManager()

    private let keychainService = "com.yourapp.AIText" // 用你的应用标识符替换

    // 获取 API 密钥
    func getAPIKey(service: AIService) -> String? {
        guard let data = load(service: service) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    // 保存 API 密钥
    func saveAPIKey(service: AIService, key: String) {
        save(service: service, key: key)
    }

    // 从 Keychain 加载数据
    private func load(service: AIService) -> Data? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: keychainService,
            kSecAttrAccount: service.rawValue,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess, let data = result as? Data {
            return data
        } else {
            return nil
        }
    }

    // 将数据保存到 Keychain
    private func save(service: AIService, key: String) {
        // 删除旧的 key
        delete(service: service)

        let data = key.data(using: .utf8)!

        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: keychainService,
            kSecAttrAccount: service.rawValue,
            kSecValueData: data
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        if status != errSecSuccess {
            print("Failed to save key to Keychain.")
        }
    }

    // 删除 Keychain 中的密钥
    private func delete(service: AIService) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: keychainService,
            kSecAttrAccount: service.rawValue
        ]

        let status = SecItemDelete(query as CFDictionary)

        if status != errSecSuccess && status != errSecItemNotFound {
            print("Failed to delete key from Keychain.")
        }
    }
}
