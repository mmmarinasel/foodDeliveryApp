import Foundation
import UIKit

protocol IFoodLoader {
    func downloadFoodDescription(urlString: String, completion: @escaping (FoodDescription) -> Void)
    func getData(urlString: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class NetworkManager: IFoodLoader {

    public var defaultURL: String = "https://api.spoonacular.com/recipes/"
//    public let token: String = "818b821c11004583bd6b95454b9253ad"
//    public let token: String = "621cf00326834aeb96a6659e1474ced4"
    public var id: Int = 716429
    
    func downloadFoodDescription(urlString: String,
                                 completion: @escaping (FoodDescription) -> Void) {
        getData(urlString: urlString) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
//            print(data)
            do {
                let foodDescription = try JSONDecoder().decode(FoodDescription.self,
                                                               from: data)
                completion(foodDescription)
            } catch {
                print(error.localizedDescription)
                print(error)
            }
        }
    }
    
    func getData(urlString: String,
                 completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func getURLString(counter: Int) -> String {
        let defaultURL: String = "https://api.spoonacular.com/recipes/"
//        let token: String = "818b821c11004583bd6b95454b9253ad"
        let token = "621cf00326834aeb96a6659e1474ced4"
        let id: Int = 716429
        let urlString = "\(defaultURL)\(id + counter)/information?includeNutrition=false&apiKey=\(token)"
        return urlString
    }
    
    func loadImageFromURL(urlString: String, completion: @escaping (UIImage) -> Void) {
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
