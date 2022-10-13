import Foundation

protocol ILoader {
    func downloadFoodDescription(urlString: String, completion: @escaping (FoodDescription) -> ())
    func getData(urlString: String, completion: @escaping (Data?, URLResponse?, Error?) -> ())
}

class NetworkManager: ILoader {
    
//    let a = "\(defaultURL)\(id)information?includeNutrition=false&apiKey=\(token)"

    public var defaultURL: String = "https://api.spoonacular.com/recipes/"
    public let token: String = "818b821c11004583bd6b95454b9253ad"
    public var id: Int = 716429
    
    func downloadFoodDescription(urlString: String, completion: @escaping (FoodDescription) -> ()) {
        getData(urlString: urlString) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            
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
    
    func getData(urlString: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func getURLString(counter: Int) -> String {
        var defaultURL: String = "https://api.spoonacular.com/recipes/"
        let token: String = "818b821c11004583bd6b95454b9253ad"
        var id: Int = 716429
        
        let urlString = "\(defaultURL)\(id + counter)information?includeNutrition=false&apiKey=\(token)"
        
        return urlString
    }
}
