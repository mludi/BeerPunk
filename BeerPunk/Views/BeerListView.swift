import SwiftUI

struct BeerListView: View {
    @StateObject private var viewModel: BeerListViewModel

    init(apiClient: APIService) {
        self._viewModel = StateObject(wrappedValue: BeerListViewModel(apiClient: apiClient))
    }

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.hasErrorMessage {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                }

                // Todo: show loading indicator
                List {
                    ForEach(viewModel.beers) { beer in
                        // Dirty Hack, ey Apple!
                        // https://developer.apple.com/forums/thread/717057
                        HStack {
                            NavigationLink {
                                BeerDetailView(beer: beer)
                            } label: {
                                BeerListRowView(beer: beer)
                                    .onAppear {
                                        onAppearBeerListRow(for: beer)
                                    }
                            }
                        }
                    }
                }
                .navigationTitle("Beers")
            }
        }
        .task {
            await viewModel.fetchBeers()
        }
    }

    private func onAppearBeerListRow(for beer: Beer) {
        if viewModel.beers.last == beer {
            Task {
                await viewModel.fetchBeers()
            }
        }
    }
}

#if DEBUG
struct BeerListView_Previews: PreviewProvider {
    static var previews: some View {
        BeerListView(apiClient: MockedAPIClient())
    }
}
#endif
