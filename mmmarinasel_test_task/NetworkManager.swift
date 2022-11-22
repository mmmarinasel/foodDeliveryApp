import Foundation
import UIKit

protocol ILoader {
    static func getJson<T: Codable>(urlString: String, completion: @escaping (T) -> Void)
    static func getData(urlString: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    static func getPicturesJson(urlString: String, completion: @escaping ([PictureModel]) -> Void)
}

protocol IPicturesLoader {
    static func loadImageFromURL(urlString: String, completion: @escaping (UIImage) -> Void)
}

class NetworkManager: ILoader, IPicturesLoader {

    public var defaultURL: String = "https://api.spoonacular.com/recipes/"
    public var idReceipt: Int = 716429
    
    static func getJson<T: Codable>(urlString: String, completion: @escaping (T) -> Void) {
        NetworkManager.getData(urlString: urlString) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            do {
                let json = try JSONDecoder().decode(T.self,
                                                    from: data)
                completion(json)
            } catch {
                print(error.localizedDescription)
                print(error)
            }
        }
    }
    
    static func getPicturesJson(urlString: String, completion: @escaping ([PictureModel]) -> Void) {
        NetworkManager.getData(urlString: urlString) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            do {
                let json = try JSONDecoder().decode([PictureModel].self,
                                                    from: data)
                completion(json)
            } catch {
                print(error.localizedDescription)
                print(error)
            }
        }
    }
    
    static func getData(urlString: String,
                 completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    static func getURLString(counter: Int) -> String {
        let defaultURL: String = "https://api.spoonacular.com/recipes/"
//        let token: String = "818b821c11004583bd6b95454b9253ad"
        let token = "621cf00326834aeb96a6659e1474ced4"
        let id: Int = 716429
        let urlString = "\(defaultURL)\(id + counter)/information?includeNutrition=false&apiKey=\(token)"
        return urlString
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
