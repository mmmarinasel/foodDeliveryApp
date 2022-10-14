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
    }



}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRow
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 160))
        headerView.backgroundColor = .systemPink
        
//        let scrollView = UIScrollView(frame: CGRect( x: 0,
//                                                     y: 0,
//                                                     width: tableView.frame.width,
//                                                     height: 112))
        
        let scrollView = UIScrollView()
        scrollView.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 112).isActive = true
//        let stackView = UIStackView(frame: CGRect(x: 0,
//                                                  y: 0,
//                                                  width: ,
//                                                  height: scrollView.frame.height))
        headerView.addSubview(scrollView)
        let stackView = UIStackView()
        
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        
        scrollView.backgroundColor = .orange
        stackView.backgroundColor = .green
        
        
        scrollView.addSubview(stackView)
        
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
