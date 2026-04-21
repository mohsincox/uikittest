import Foundation
import Security

enum KeychainStorageKey: String, CaseIterable {
    case accessToken = "com.laraapp.access_token"
    case userName    = "com.laraapp.user_name"
    case userEmail   = "com.laraapp.user_email"
    case userId      = "com.laraapp.user_id"
}

final class KeychainStorageManager {
    static let shared = KeychainStorageManager()

    private var memoryCache: [String: String] = [:]

    private init() {}

    func get(_ key: KeychainStorageKey) -> String? {
        if let cached = memoryCache[key.rawValue] { return cached }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data,
              let value = String(data: data, encoding: .utf8) else { return nil }

        memoryCache[key.rawValue] = value
        return value
    }

    @discardableResult
    func save(_ value: String, for key: KeychainStorageKey) -> Bool {
        memoryCache[key.rawValue] = value
        let data = Data(value.utf8)
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key.rawValue]
        SecItemDelete(query as CFDictionary)
        let attrs: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key.rawValue,
                                    kSecValueData as String: data]
        return SecItemAdd(attrs as CFDictionary, nil) == errSecSuccess
    }

    @discardableResult
    func delete(_ key: KeychainStorageKey) -> Bool {
        memoryCache.removeValue(forKey: key.rawValue)
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key.rawValue]
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }

    func clearAll() {
        memoryCache.removeAll()
        KeychainStorageKey.allCases.forEach { delete($0) }
    }
}
