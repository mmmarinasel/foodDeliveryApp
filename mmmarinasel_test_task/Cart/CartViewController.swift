import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var cartTableView: UITableView!
    
    private let heightForHeader: CGFloat = 160
    private let heightForCell: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cartTableView.register(UINib(nibName: "CartHeaderTableView",
                                          bundle: nil),
                                    forHeaderFooterViewReuseIdentifier: CartHeaderTableView.reuseIdentifier)
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.heightForHeader
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CartHeaderTableView.reuseIdentifier) as? CartHeaderTableView
        else { return CartHeaderTableView() }
        headerView.orderButton.layer.cornerRadius = 16
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: true)
    }
}

extension CartViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell") as? CartTableViewCell
        else { return CartTableViewCell() }
        
        return cell
    }

}
