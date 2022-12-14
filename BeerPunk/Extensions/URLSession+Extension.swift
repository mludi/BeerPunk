import Foundation

extension URLSession {
    func request(endpoint: Endpoint) async throws -> (Data, URLResponse) {
        let (data, response) = try await self.data(for: endpoint.urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidServerResponse
        }

        if httpResponse.statusCode == 401 {
            throw APIError.unauthorized
        }

        if httpResponse.statusCode == 422 {
            throw APIError.validationFailed
        }

        if !(200...299).contains(httpResponse.statusCode) {
            throw APIError.requestFailed(httpResponse.statusCode)
        }

        if
            let xRateLimitString = (httpResponse.allHeaderFields["x-ratelimit-limit"] as? String),
            let rateLimit = Int(xRateLimitString),
            let xRateLimitRemainingString = (httpResponse.allHeaderFields["x-ratelimit-remaining"] as? String),
            let rateLimitRemaining = Int(xRateLimitRemainingString)
        {
            UserDefaults.rateLimit = rateLimit
            UserDefaults.rateLimitRemaining = rateLimitRemaining
        }

        return (data, response)
    }
}

