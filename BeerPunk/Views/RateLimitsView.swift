import SwiftUI

struct RateLimitsView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                Text("This a free API, be careful and respectful with rate limits :]")
                    .font(.body)
                    .foregroundColor(.secondary)
                VStack {
                    Text("Rate Limit: \(UserDefaults.rateLimit)")
                    Text("Remaining Request: \(UserDefaults.rateLimitRemaining)")
                }
                .padding()

                VStack(alignment: .leading) {
                    Text("To make sure everyone can access the API reliably, each IP that makes a request has a rate limit of 3600 requests per hour.")

                    Text("This works out at 1 req/sec. This is an initial figure, if the servers hold up I will definitely consider bumping this number.")

                    Text("You can see what the rate limit is and how many requests are remaining by looking at the rate limit headers sent in the response.")
                }
                .padding()
                .font(.footnote)
            }
            .navigationTitle("Rate Limits")
        }
    }
}

struct RateLimitsView_Previews: PreviewProvider {
    static var previews: some View {
        RateLimitsView()
    }
}
