import Combine
import Foundation

final class SearchBeersListViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published private(set) var beers: [Beer] = []
    @Published private(set) var errorMessage = ""
    private var cancellables = Set<AnyCancellable>()

    private let apiClient: APIService

    init(apiClient: APIService) {
        self.apiClient = apiClient

        $searchQuery
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .filter { $0.count >= 3 }
            .sink { [weak self] query in
                guard let self = self else {
                    return
                }
                Task {
                    await self.searchBreweries(for: query)
                }
            }
            .store(in: &cancellables)
    }

    var hasErrorMessage: Bool {
        !errorMessage.isEmpty
    }

    @MainActor
    private func searchBreweries(for name: String) async {
        do {
            self.beers = try await apiClient.search(for: name)
        }
        catch {
            print(error)
            self.errorMessage = error.localizedDescription
        }
    }
}
