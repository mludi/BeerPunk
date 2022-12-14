import Foundation

struct Endpoint {
    struct URLHeaderField {
        let field: String
        let value: String
    }

    enum HTTPMethod: CustomStringConvertible {
        case get
        case post(Data?)
        case delete
        case patch(Data?)

        var description: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .delete: return "DELETE"
            case .patch: return "PATCH"
            }
        }
    }

    let path: String
    var httpMethod: HTTPMethod = .get
    var queryItems: [URLQueryItem] = []
    var headerFields: [URLHeaderField] = []
}

extension Endpoint {
    var urlRequest: URLRequest {
        var urlComponents = URLComponents()

        urlComponents.scheme = "https"
        urlComponents.host = "api.punkapi.com"
        urlComponents.path = "/v2/\(path)"

        // only append if count > 0, otherwise it will add a `?` sign and request might fail
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else {
            preconditionFailure("Invalid URLComponents: \(urlComponents)")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "\(httpMethod)"

        switch httpMethod {
        case let .post(body), let .patch(body):
            urlRequest.httpBody = body
        default:
            break
        }

        urlRequest.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        headerFields.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }

        return urlRequest
    }
}

extension Endpoint {
    static func all(
        page: Int = 1,
        pageSize: Int = 25
    ) -> Self {
        Self(
            path: "beers",
            queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "\(pageSize)")
            ]
        )
    }

    static func search(
        name: String
    ) -> Self {
        Self(
            path: "beers",
            queryItems: [
                URLQueryItem(name: "beer_name", value: name)
            ]
        )
    }

    static var random: Self {
        Self(path: "beers/random")
    }
}
