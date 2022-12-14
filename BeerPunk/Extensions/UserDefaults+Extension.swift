import Foundation

extension UserDefaults {
    @UserDefault(key: "x-rate-limit", defaultValue: 0)
    static var rateLimit: Int

    @UserDefault(key: "x-rate-limit-remaining", defaultValue: 0)
    static var rateLimitRemaining: Int
}
