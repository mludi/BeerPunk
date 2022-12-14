import SwiftUI

struct SearchBeersListView: View {
    @StateObject private var viewModel: SearchBeersListViewModel

    init(apiClient: APIService) {
        self._viewModel = StateObject(wrappedValue: SearchBeersListViewModel(apiClient: apiClient))
    }

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.hasErrorMessage {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                }
                List {
                    ForEach(viewModel.beers) { beer in
                        // Dirty Hack, ey Apple!
                        // https://developer.apple.com/forums/thread/717057
                        HStack {
                            NavigationLink {
                                BeerDetailView(beer: beer)
                            } label: {
                                BeerListRowView(beer: beer)
                            }
                        }
                    }
                }
                .navigationTitle("Search beers")
                .searchable(text: $viewModel.searchQuery)
            }
        }
    }
}

struct SearchBeersListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBeersListView(apiClient: MockedAPIClient())
    }
}
