import SwiftUI

struct BeerListRowView: View {
    let beer: Beer

    var body: some View {
        HStack {
// enable if you like, it's buggy at the moment
//            if let imageURL = beer.imageURL {
//                AsyncImage(
//                    url: imageURL,
//                    content: { image in
//                        image
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(maxWidth: 50, maxHeight: 50)
//                    },
//                    placeholder: {
//                        ProgressView()
//                    }
//                )
//            }
            VStack(alignment: .leading, spacing: 4) {
                Text(beer.name)
                    .font(.title3)
                Text(beer.tagline)
                    .foregroundColor(.secondary)
                    .font(.headline)
                Text("\(beer.abv, specifier: "%.2f")%")
                    .font(.footnote)
            }
        }
    }
}

#if DEBUG
struct BeerListRowView_Previews: PreviewProvider {
    static var previews: some View {
        BeerListRowView(beer: Beer.demoData.first!)
    }
}
#endif
