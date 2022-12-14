import SwiftUI

@main
struct AppRoot: App {
    let apiClient = APIClient()
    @State private var showRateLimits = false

    var body: some Scene {
        WindowGroup {
            TabView {
                BeerListView(apiClient: apiClient)
                    .tabItem {
                        Label("Beers", systemImage: "wineglass")
                    }
                RandomBeerView(apiClient: apiClient)
                    .tabItem {
                        Label("Random", systemImage: "dice")
                    }
                SearchBeersListView(apiClient: apiClient)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
            }
            .sheet(isPresented: $showRateLimits) {
                RateLimitsView()
            }
            .onShake {
                if UserDefaults.rateLimit > 0 && UserDefaults.rateLimitRemaining > 0 {
                    showRateLimits.toggle()
                }
            }
        }
    }
}
