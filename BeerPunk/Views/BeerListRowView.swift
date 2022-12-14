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
                if let name = beer.name {
                    Text(name)
                        .font(.title3)
                }
                if let tagline = beer.tagline {
                    Text(tagline)
                        .foregroundColor(.secondary)
                        .font(.headline)
                }
                Text("\(beer.abv, specifier: "%.2f")%")
                    .font(.footnote)
            }
            Spacer()
            // Please, rewrite me!
            if beer.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
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
