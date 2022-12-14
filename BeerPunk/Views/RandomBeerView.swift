import SwiftUI

struct RandomBeerView: View {
    @StateObject private var viewModel: RandomBeerViewModel

    init(apiClient: APIService) {
        self._viewModel = StateObject(wrappedValue: RandomBeerViewModel(apiClient: apiClient))
    }

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack {
                        if viewModel.hasErrorMessage {
                            Text(viewModel.errorMessage)
                                .foregroundColor(.red)
                        }

                        if let beer = viewModel.randomBeer {
                            BeerDetailView(beer: beer)
                        }
                    }
                    .padding()
                    .frame(width: proxy.size.width)
                    .frame(minHeight: proxy.size.height)
                }
            }
            .refreshable {
                await viewModel.fetchRandomBeer()
            }
            .task {
                await viewModel.fetchRandomBeer()
            }
        }
    }
}

#if DEBUG
struct RandomBeerView_Previews: PreviewProvider {
    static var previews: some View {
        RandomBeerView(apiClient: MockedAPIClient())
    }
}
#endif
