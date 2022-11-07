import UIKit

class CartHeaderTableView: UITableViewHeaderFooterView {

    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var orderButton: UIButton!
    
    @IBAction func orderHandleButton(_ sender: Any) {
//        print("ORDER ORDER")
    }
    static let reuseIdentifier = "CartHeaderID"
}
