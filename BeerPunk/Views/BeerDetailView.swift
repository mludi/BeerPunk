import SwiftUI

struct BeerDetailView: View {
    let beer: Beer

    var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack {
                    if let desc = beer.desc {
                        Text(desc)
                            .multilineTextAlignment(.center)
                    }
                    Button {
                        print("Here we can store favorites")
                    } label: {
                        Label("Toggle Favorite", systemImage: beer.isFavorite ? "star.fill" : "star")
                            .labelStyle(.iconOnly)
                            .foregroundColor(Color.yellow)
                    }

                    Spacer()
                    VStack {
                        if let firstBrewed = beer.firstBrewed {
                            self.firstBrewed(for: firstBrewed)
                        }
                        Text("\(beer.abv, specifier: "%.2f")%")
                            .font(.footnote)
                    }
                    .font(.subheadline.monospacedDigit())
                    .foregroundColor(.secondary)

                    if let imageURL = beer.imageURL {
                        image(for: imageURL, proxy: proxy)
                    }
                    Spacer()
                    foodPairing(for: beer)
                }
            }
            .padding()
            .navigationTitle(beer.name ?? "")
        }
    }

    private func image(for url: URL, proxy: GeometryProxy) -> some View {
        AsyncImage(
            url: url,
            content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: proxy.size.width / 2, maxHeight: proxy.size.height / 2)
            },
            placeholder: {
                ProgressView()
            }
        )
    }

    private func firstBrewed(for firstBrewed: Date) -> some View {
        HStack(spacing: 2) {
            Text("First brewed on:")
            Text(firstBrewed, style: .date)
        }
    }

    private func foodPairing(for beer: Beer) -> some View {
        VStack {
            Text("Food Pairing")
                .font(.title2)
            Spacer()
            if
                let beerFoodPairing = beer.foodPairing,
                !beerFoodPairing.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(beerFoodPairing, id: \.self) { foodPairing in
                            Text(foodPairing)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .strokeBorder(.purple, lineWidth: 4)
                                )
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#if DEBUG
struct BeerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BeerDetailView(beer: Beer.demoData.first!)
    }
}
#endif
