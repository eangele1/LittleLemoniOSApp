import Foundation

struct MenuItem: Decodable {
    let title: String
    let image: String
    let price: String
    let itemDescription: String
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case itemDescription = "description"
        case title = "title"
        case image = "image"
        case price = "price"
        case category = "category"
    }
    
}
