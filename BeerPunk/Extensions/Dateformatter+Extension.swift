import Foundation

extension DateFormatter {
    static let beerPunk: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        return formatter
    }()
}
