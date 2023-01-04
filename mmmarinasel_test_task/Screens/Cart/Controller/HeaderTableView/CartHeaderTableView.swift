import UIKit

class CartHeaderTableView: UITableViewHeaderFooterView {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var saveAddressButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    
    @IBAction func orderHandleButton(_ sender: Any) {
//        print("ORDER ORDER ORDER ORDER ORDER ORDER ORDER")
//        let lm = LocationManager.shared
//        lm.requestAccess { isSuccess in
//            if isSuccess {
//                lm.getLocation { location in
//                    print(location)
//                }
//            }
//        }
    }

    @IBOutlet weak var changeLocationButton: UIButton!
    
    static let reuseIdentifier = "CartHeaderID"
    
    func setAddress(address: String?) {
        guard let address = address else { return }
        self.addressTextView.text = address
    }
}
