import Foundation

protocol APIService {
    func all(page: Int) async throws -> [Beer]
    func search(for name: String) async throws -> [Beer]
    func random() async throws -> Beer
}

extension APIService {
    func all(page: Int = 0) async throws -> [Beer] {
        try await self.all(page: page)
    }
}

final class APIClient: APIService {
    private let dateFormatter = DateFormatter()

    private lazy var jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        // sometimes first_brewed onl has a year
        // https://stackoverflow.com/a/50850604/1518174
        jsonDecoder.dateDecodingStrategy = .custom { [weak self] decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            self?.dateFormatter.dateFormat = "MM/yyyy"

            if let date = self?.dateFormatter.date(from: dateString) {
                return date
            }

            self?.dateFormatter.dateFormat = "yyyy"

            if let date = self?.dateFormatter.date(from: dateString) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string \(dateString)"
            )
        }
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()

    func all(page: Int = 1) async throws -> [Beer] {
        let (data, _) = try await URLSession.shared.request(endpoint: .all(page: page))
        let beers: [Beer] = try await decode(data: data)
        return beers
    }

    func search(for name: String) async throws -> [Beer] {
        let (data, _) = try await URLSession.shared.request(endpoint: .search(name: name))
        let beers: [Beer] = try await decode(data: data)
        return beers
    }

    func random() async throws -> Beer {
        let (data, _) = try await URLSession.shared.request(endpoint: .random)
        let beers: [Beer] = try await decode(data: data)
        guard let beer = beers.first else {
            throw APIError.invalidData
        }
        return beer
    }
}

extension APIClient {
    private func decode<T: Decodable>(data: Data) async throws -> T {
        do {
            let result = try jsonDecoder.decode(T.self, from: data)
            return result
        } catch {
            throw APIError.jsonConversionFailure(error)
        }
    }
}

final class MockedAPIClient: APIService {
    func all(page: Int) async throws -> [Beer] {
        Beer.demoData
    }

    func random() async throws -> Beer {
        Beer.demoData.randomElement()!
    }

    func search(for name: String) async throws -> [Beer] {
        Beer.demoData.filter { $0.name.contains(name) }
    }
}
