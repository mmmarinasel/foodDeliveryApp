import UIKit

class CartHeaderTableView: UITableViewHeaderFooterView {

    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var orderButton: UIButton!
    
    @IBAction func orderHandleButton(_ sender: Any) {
        print("ORDER ORDER ORDER ORDER ORDER ORDER ORDER")
    }

    @IBOutlet weak var changeLocationButton: UIButton!
    
    static let reuseIdentifier = "CartHeaderID"
}
