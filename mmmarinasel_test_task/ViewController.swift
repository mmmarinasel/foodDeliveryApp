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
//        let queue = DispatchQueue.global(qos: .userInteractive )
////        DispatchQueue.global().async {
//        queue.async {
////            for i in 0...self.foodCount {
//                self.urlString = self.loader.getURLString(counter: /*i*/0)
//                self.loader.downloadFoodDescription(urlString: self.urlString) { [weak self] data in
//                    self?.foodDescription.append(data)
//                    print(data)
//                }
//
//            DispatchQueue.main.async {
//                self.foodTableView.reloadData()
//            }
//
//        }
        
        self.foodTableView.register(UINib(nibName: "HeaderTableView", bundle: nil),
                                    forHeaderFooterViewReuseIdentifier: HeaderTableView.reuseIdentifier)
    }



}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRow
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 192
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderTableView.reuseIdentifier) as? HeaderTableView else { return HeaderTableView() }
 
        headerView.stackView.spacing = 16
        headerView.categoriesStackView.spacing = 8
        
        headerView.addImageView(imgName: "food_ad1")
        headerView.addImageView(imgName: "food_ad2")
        headerView.addImageView(imgName: "food_ad3")
        headerView.addImageView(imgName: "food_ad4")
        headerView.addImageView(imgName: "food_ad5")
        
        headerView.addButton(name: "Пицца")
        headerView.addButton(name: "Паста")
        headerView.addButton(name: "Комбо")
        headerView.addButton(name: "Десерты")
        headerView.addButton(name: "Напитки")
        
        return headerView
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.foodDescription.count
        return 5
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell") as? FoodTableViewCell else { return FoodTableViewCell() }
        
//        DispatchQueue.main.async {
//            var ingredients = self.foodDescription[indexPath.row].extendedIngredients
//            for ingredient in ingredients {
//                var cellIngrediantsDescription = ""
//                if ingredient.name == ingredients.last?.name {
//                    cell.descriptionLabel.text += ingredient.name
//                } else {
//                    cell.descriptionLabel.text += "\(ingredient.name), "
//                }
//            }
//        }
        cell.descriptionLabel.isEditable = false
        return cell
    }
    
    
}
