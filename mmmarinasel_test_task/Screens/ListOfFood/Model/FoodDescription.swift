import Foundation
import UIKit

typealias Categories = [Category]
typealias FoodDescriptions = [FoodDescription]

struct FoodDescription: Codable {
    var id: Int
    var categoryId: Int
    var price: String
    var title: String
    var description: String
    var imageURL: String
    enum CodingKeys: String, CodingKey {
        case id
        case categoryId = "category_id"
        case price
        case title
        case description = "descr"
        case imageURL = "img_url"
    }
}

struct Category: Codable {
    var id: Int
    var name: String
}

struct Menu {
    var category: Category
    var products: FoodDescriptions
}
