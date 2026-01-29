import Foundation

struct StoredTokens: Codable {
    var accessToken: String
    var refreshToken: String?
    var expiresAt: Int64 // milliseconds since epoch
}

enum TokenStore {
    private static let tokenDir = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent(".config/claude-usage-monitor")
    private static let tokenFile = tokenDir.appendingPathComponent("tokens.json")

    static func load() throws -> StoredTokens {
        guard FileManager.default.fileExists(atPath: tokenFile.path) else {
            throw TokenStoreError.noToken
        }
        let data = try Data(contentsOf: tokenFile)
        return try JSONDecoder().decode(StoredTokens.self, from: data)
    }

    static func save(_ tokens: StoredTokens) throws {
        try FileManager.default.createDirectory(at: tokenDir, withIntermediateDirectories: true)
        let data = try JSONEncoder().encode(tokens)
        try data.write(to: tokenFile)
        try FileManager.default.setAttributes(
            [.posixPermissions: 0o600], ofItemAtPath: tokenFile.path)
    }

    static func clear() {
        try? FileManager.default.removeItem(at: tokenFile)
    }
}

enum TokenStoreError: LocalizedError {
    case noToken

    var errorDescription: String? {
        switch self {
        case .noToken:
            return "No token configured"
        }
    }
}
