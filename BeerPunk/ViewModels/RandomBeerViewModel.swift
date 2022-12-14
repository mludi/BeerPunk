import Foundation

final class RandomBeerViewModel: ObservableObject {
    private let apiClient: APIService

    @Published private(set) var randomBeer: Beer?
    @Published private(set) var errorMessage = ""

    init(apiClient: APIService) {
        self.apiClient = apiClient
    }

    var hasErrorMessage: Bool {
        !errorMessage.isEmpty
    }

    @MainActor
    func fetchRandomBeer() async {
        do {
            self.randomBeer = try await apiClient.random()
        }
        catch {
            print(error)
            self.errorMessage = error.localizedDescription
        }
    }
}
