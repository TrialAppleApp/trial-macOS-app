//
//  PasswordManager.swift
//  TrialMacAppGUI
//
//  Created by TrialMacApp on 12/23/24.
//

import Foundation

protocol PasswordManager {
    func savePassword(_ password: String) -> Bool
    func getPassword() -> String?
}

// UserDefaults 实现
class UserDefaultsPasswordSaver: PasswordManager {
    static let shared = UserDefaultsPasswordSaver()
    private let key = "userPassword"

    func savePassword(_ password: String) -> Bool {
        UserDefaults.standard.set(password, forKey: key)
        return true
    }

    func getPassword() -> String? {
        UserDefaults.standard.string(forKey: key)
    }
}

class KeychainPasswordSaver: PasswordManager {
    static let shared = KeychainPasswordSaver()

    func savePassword(_ password: String) -> Bool {
        let data = password.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Constants.appName,
            kSecAttrAccount as String: Constants.authorName,
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary) // 删除旧的密码
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }

    func getPassword() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Constants.appName,
            kSecAttrAccount as String: Constants.authorName,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        guard status == errSecSuccess, let data = dataTypeRef as? Data else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}
