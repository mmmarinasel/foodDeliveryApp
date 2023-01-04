import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var foodTableView: UITableView!
    @IBOutlet weak var greetingLabel: UILabel!
    
    private let heightForRow: CGFloat = 200
    private let heightForHeader: CGFloat = 192

    private var counter: Int = 0
    public var foodData: FoodDescriptions = [] // FoodDescriptions()
    public var categories: Categories = [] // Categories()
//    public var menu: [Category : FoodDescriptions] = [:]
    public var menu: [Menu] = []
    private var selectedCategoryId: Int?
    
    private lazy var profileModel: ProfileModel = {
        return ProfileModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.foodTableView.register(UINib(nibName: "HeaderTableView", bundle: nil),
                                    forHeaderFooterViewReuseIdentifier: HeaderTableView.reuseIdentifier)

        NetworkManager.getJson(urlString: NetworkManager.categoriesURL) { [weak self] categories in
            self?.categories = categories
            self?.selectedCategoryId = self?.categories[0].id ?? 0
            self?.buildMenu()
            DispatchQueue.main.async {
                self?.foodTableView.reloadData()
            }
        }
        
        NetworkManager.getJson(urlString: NetworkManager.foodURL) { [weak self] data in
            self?.foodData = data
            self?.buildMenu()
            DispatchQueue.main.async {
                self?.foodTableView.reloadData()
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
    
    func buildMenu() {
        guard !self.categories.isEmpty && !self.foodData.isEmpty else { return }
        var products: FoodDescriptions = []
        for category in self.categories {
            products = []
            for product in self.foodData where product.categoryId == category.id {
                products.append(product)
            }
            self.menu.append(Menu(category: category, products: products))
        }
    }
}

    // MARK: - CategoryDelegate

extension ViewController: CategoryDelegate {
    
    func setCategory(_ categoryId: Int) {
        self.selectedCategoryId = categoryId
        self.foodTableView.reloadData()
    }
}

    // MARK: - UITableViewDelegate

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
        if !self.categories.isEmpty && self.counter == 0 {
            headerView.stackView.spacing = 16
            headerView.categoriesStackView.spacing = 8
            headerView.addImageView(imgName: "food_ad1")
            headerView.addImageView(imgName: "food_ad2")
            headerView.addImageView(imgName: "food_ad3")
            headerView.addImageView(imgName: "food_ad4")
            headerView.addImageView(imgName: "food_ad5")
            for idx in 0..<self.categories.count {
                headerView.addButton(name: self.categories[idx].name, categoryId: self.categories[idx].id)
            }
            self.counter += 1
        }
        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: true)
    }
}

    // MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !self.menu.isEmpty else { return 0 }
        let filtered = self.menu.first(where: { $0.category.id == self.selectedCategoryId })
        return filtered?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell") as? FoodTableViewCell
        else { return FoodTableViewCell() }
        DispatchQueue.main.async {
            let item = self.menu.first(where: { $0.category.id == self.selectedCategoryId })
            cell.nameLabel.text = item?.products[indexPath.row].title
            cell.descriptionLabel.text = item?.products[indexPath.row].description
            cell.priceButton.setTitle("\(item?.products[indexPath.row].price ?? "0") $", for: .normal)
            cell.foodImageView.image = UIImage(named: "placeholder-image")
            NetworkManager.loadImageFromURL(urlString: item?.products[indexPath.row].imageURL ?? "") { img in
                cell.foodImageView.image = img
            }
        }
        cell.descriptionLabel.isEditable = false
        cell.priceButton.layer.cornerRadius = 5
        cell.priceButton.layer.borderWidth = 1
        cell.priceButton.layer.borderColor = UIColor(named: "price_btn")?.cgColor
        return cell
    }
}
