import UIKit

class CartHeaderTableView: UITableViewHeaderFooterView {

    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    static let reuseIdentifier = "CartHeaderID"
}
