import Foundation

struct PictureModel: Codable {
    let id: String
    let urls: Urls
}

struct Urls: Codable {
    let raw: String
    let small: String
}
