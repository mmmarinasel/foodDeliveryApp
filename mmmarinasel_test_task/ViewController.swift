import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var foodTableView: UITableView!
    
    private var heightForRow: CGFloat = 180
    private var foodCount: Int = 30
    
    public var foodDescription: [FoodDescription] = []
    private let loader = NetworkManager()
    private var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DispatchQueue.global().async {
            for _ in 0...self.foodCount {
                self.loader.downloadFoodDescription(urlString: self.urlString) { [weak self] data in
                    self?.foodDescription.append(data)
                }
            }
            
        }
    }


}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRow
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 160
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foodCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell") as? FoodTableViewCell else { return FoodTableViewCell() }
        
//        DispatchQueue.main.async {
//            var ingredients = self.foodDescription[indexPath.row].extendedIngredients
//            for ingredient in ingredients {
////                var cellIngrediantsDescription = ""
//                if ingredient.name == ingredients.last?.name {
//                    cell.descriptionLabel.text += ingredient.name
//                } else {
//                    cell.descriptionLabel.text += "\(ingredient.name), "
//                }
//            }
//        }
//        
//        return cell
//    }
    
    
}
