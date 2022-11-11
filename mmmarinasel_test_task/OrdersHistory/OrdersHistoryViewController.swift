import UIKit

class OrdersHistoryViewController: UIViewController {

    @IBOutlet weak var ordersHistoryTableView: UITableView!
    
    private let cellId: String = "orderCell"
    private let cellHeight: CGFloat = 100
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension OrdersHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.cellHeight
    }
}

extension OrdersHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId) as? OrderTableViewCell
        else { return OrderTableViewCell() }
        
        return cell
    }
}
