import Foundation
import UIKit

protocol ILoader {
    static func getJson<T: Codable>(urlString: String, completion: @escaping ([T]) -> Void)
    static func getData(urlString: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
//    static func getPicturesJson(urlString: String, completion: @escaping ([PictureModel]) -> Void)
}

protocol IPicturesLoader {
    static func loadImageFromURL(urlString: String, completion: @escaping (UIImage) -> Void)
}

class NetworkManager: ILoader, IPicturesLoader {

//    public var defaultURL: String = "https://api.spoonacular.com/recipes/"
//    public var idReceipt: Int = 716429
    static var categoriesURL: String = "http://89.108.99.78:3000/categories"
    static var foodURL: String = "http://89.108.99.78:3000/products"
    static var picturesURL: String = "https://api.unsplash.com/photos/?client_id=RDTgAwXSjpgiUCmhnvEhTqQ-lYoE7FGHg2aGJo0vGEQ"
    
    static func getJson<T: Codable>(urlString: String, completion: @escaping ([T]) -> Void) {
        NetworkManager.getData(urlString: urlString) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            do {
                let json = try JSONDecoder().decode([T].self,
                                                    from: data)
                completion(json)
            } catch {
                print(error.localizedDescription)
                print(error)
            }
        }
    }
    
//    static func getPicturesJson(urlString: String, completion: @escaping ([PictureModel]) -> Void) {
//        NetworkManager.getData(urlString: urlString) { data, _, error in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            guard let data = data else { return }
//            do {
//                let json = try JSONDecoder().decode([PictureModel].self,
//                                                    from: data)
//                completion(json)
//            } catch {
//                print(error.localizedDescription)
//                print(error)
//            }
//        }
//    }
    
    static func getData(urlString: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    static func loadImageFromURL(urlString: String, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global().async {
            if let url = URL(string: urlString),
               let imageData = try? Data(contentsOf: url),
               let img = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    completion(img)
                }
            }
        }
    }
}
