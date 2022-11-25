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
    @objc func buildAlert(sender: UIButton!) {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let mapButton = UIAlertAction(title: "Open map",
                                      style: .default) { [weak self] _ in
            self?.openMap()
        }
        let enterManuallyButton = UIAlertAction(title: "Enter manually",
                                                style: .default) { [weak self] _ in
            
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(mapButton)
        alert.addAction(enterManuallyButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    func openMap() {
        let story = UIStoryboard(name: "Map", bundle: nil)
        let vc = story.instantiateViewController(identifier: "mapVC") as? MapViewController
        guard let vcontroller = vc else { return }
        self.present(vcontroller, animated: true, completion: nil)
      }
    
    func changeAdressManually(textView: UITextView) {
        textView.isEditable = true
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
        headerView.addressTextView.isEditable = false
        headerView.orderButton.layer.cornerRadius = 16
        headerView.changeLocationButton.addTarget(self, action: #selector(buildAlert), for: .touchUpInside)
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
