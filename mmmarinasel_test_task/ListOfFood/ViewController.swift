import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var foodTableView: UITableView!
    @IBOutlet weak var greetingLabel: UILabel!
    
    private let heightForRow: CGFloat = 200
    private let heightForHeader: CGFloat = 192
    
    private var foodCount: Int = 1
    private var counter: Int = 0
    public var foodData: [FoodDescriptionOutput] = []
    
    private lazy var profileModel: ProfileModel = {
        return ProfileModel()
    }()
    private var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.foodTableView.register(UINib(nibName: "HeaderTableView", bundle: nil),
                                    forHeaderFooterViewReuseIdentifier: HeaderTableView.reuseIdentifier)
        for temp in 0...self.foodCount {
            self.urlString = NetworkManager.getURLString(counter: temp)
            NetworkManager.getJson(urlString: self.urlString) { [weak self] data in
                self?.foodData.append(FoodDescriptionOutput(data: data))
                DispatchQueue.main.async {
                    self?.foodTableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.profileModel.load { [weak self] data in
            let profileData: ProfileData = data
            guard let name = profileData.name else { return }
            DispatchQueue.main.async {
                self?.greetingLabel.text = "Hello, \(name) 🙂"
            }
        }
        
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRow
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.heightForHeader
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderTableView.reuseIdentifier) as? HeaderTableView
        else { return HeaderTableView() }
        if self.counter == 0 {
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
            self.counter += 1
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foodData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell") as? FoodTableViewCell
        else { return FoodTableViewCell() }
        
        DispatchQueue.main.async {
            let item = self.foodData[indexPath.row]
            let ingredients = item.data.extendedIngredients
            for ingredient in ingredients {
                if ingredient.name == ingredients.last?.name {
                    cell.descriptionLabel.text += ingredient.name
                } else {
                    cell.descriptionLabel.text += "\(ingredient.name), "
                }
            }
            cell.nameLabel.text = item.data.title
            if item.image == nil {
                NetworkManager.loadImageFromURL(urlString: item.data.imageURL) { [weak self] img in
                    self?.foodData[indexPath.row].image = img
                    cell.foodImageView.image = img
                }
            } else {
                cell.foodImageView.image = UIImage(named: "placeholder-image")
            }
        }
        cell.descriptionLabel.isEditable = false
        cell.priceButton.layer.cornerRadius = 5
        cell.priceButton.layer.borderWidth = 1
        cell.priceButton.layer.borderColor = UIColor(red: 246 / 255,
                                                     green: 74 / 255,
                                                     blue: 126 / 255,
                                                     alpha: 1).cgColor
        return cell
    }
}
