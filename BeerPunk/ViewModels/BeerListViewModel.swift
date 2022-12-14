import Foundation

final class BeerListViewModel: ObservableObject {
    private let apiClient: APIService

    @Published private(set) var beers: [Beer] = []
    @Published private(set) var errorMessage = ""

    private var currentPage = 1

    init(apiClient: APIService) {
        self.apiClient = apiClient
    }

    var hasErrorMessage: Bool {
        !errorMessage.isEmpty
    }

    @MainActor
    func fetchBeers() async {
        do {
            self.beers += try await apiClient.all(page: currentPage)
            if currentPage <= Constants.numberOfPages {
                currentPage = currentPage + 1
            }
        }
        catch {
            print(error)
            self.errorMessage = error.localizedDescription
        }
    }
}
