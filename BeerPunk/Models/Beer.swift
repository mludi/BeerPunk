import Foundation

struct Beer: Identifiable, Decodable {
    let id: Int
    let name: String
    let abv: Double
    let tagline: String
    let description: String
    let firstBrewed: Date?
    let foodPairing: [String]
    let imageURL: URL?

    enum CodingKeys: CodingKey {
        case id
        case abv
        case name
        case tagline
        case description
        case firstBrewed
        case foodPairing
        case imageUrl
    }

    init(
        id: Int,
        name: String,
        abv: Double,
        tagline: String,
        description: String,
        firstBrewed: Date,
        foodPairing: [String],
        imageURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.abv = abv
        self.tagline = tagline
        self.description = description
        self.firstBrewed = firstBrewed
        self.foodPairing = foodPairing
        self.imageURL = imageURL
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.abv = try container.decode(Double.self, forKey: .abv)
        self.tagline = try container.decode(String.self, forKey: .tagline)
        self.description = try container.decode(String.self, forKey: .description)
        self.firstBrewed = try container.decodeIfPresent(Date.self, forKey: .firstBrewed)
        self.foodPairing = try container.decode([String].self, forKey: .foodPairing)
        self.imageURL = try container.decodeIfPresent(URL.self, forKey: .imageUrl)
    }
}

extension Beer: Equatable {}

extension Beer {
    static let demoData = [
        Beer(
            id: 0815,
            name: "Karlsberg UrPils",
            abv: 4.8,
            tagline: "Beste wo gibt",
            description: "Charakteristischer Magnumhopfen, weiches Brauwasser und unsere begeisterten Brauer:innen stehen für dieses Pils. Gebraut nach dem deutschen Reinheitsgebot.",
            firstBrewed: Date(),
            foodPairing: ["Burger", "Steak", "Döner", "Pizza", "Pasta"],
            imageURL: URL(string: "https://karlsberg.de/wp-content/uploads/2021/01/urpils_flasche2.png")!
        ),
        Beer(
            id: 2,
            name: "Bitbruger Premium Pils",
            abv: 4.8,
            tagline: "Aus der Eifel.",
            description: "Vollendeter hopfenbetonter Pilsgenuss, einzigartig im Geschmack: Bitburger Premium Pils – das meistgezapfte Premium Pils an deutschen Theken.",
            firstBrewed: Date(),
            foodPairing: ["Pasta", "Salat"],
            imageURL: URL(string: "https://shop.bitburger.de/out/pictures/generated/product/1/640_640_75/405_bitburger-pokale_4102430040505.jpg")!
        )
    ]
}
