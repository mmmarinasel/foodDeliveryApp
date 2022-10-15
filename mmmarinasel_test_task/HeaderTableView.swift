import UIKit

protocol HeaderDelegate: class {
    func headerView(_ headerView: HeaderTableView, didTapButtonInSection section: Int)
}

class HeaderTableView: UITableViewHeaderFooterView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    static let reuseIdentifier = "HeaderID"
    
    weak var delegate: HeaderDelegate?
//    food_ad1
    
    func addImageView(imgName: String) {
        let imageView = UIImageView()
//        imageView.backgroundColor = UIColor.blue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 112).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.image = UIImage(named: imgName)
        
        
        self.stackView.addArrangedSubview(imageView)
    }
    
}
