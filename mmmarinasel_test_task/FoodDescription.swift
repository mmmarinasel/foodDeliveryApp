import Foundation

struct FoodDescription: Codable {
    
    var extendedIngredients: [Ingredient]
    var imageURL: String
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case extendedIngredients
        case imageURL = "image"
        case title
    }
}

struct Ingredient: Codable {
    var name: String
}
