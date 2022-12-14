import Foundation

enum APIError: Error, CustomStringConvertible {
    case invalidServerResponse
    case validationFailed
    case invalidData
    case requestFailed(Int?)
    case jsonConversionFailure(Error)
    case unauthorized

    var description: String {
        switch self {
        case .requestFailed(let statusCode):
            if let statusCode = statusCode {
                return "Request failed with status code \(statusCode)"
            }

            return "Request failed"
        default: return ""
        }
    }
}
