import UIKit

protocol HeaderDelegate: class {
    func headerView(_ headerView: HeaderTableView, didTapButtonInSection section: Int)
}

class HeaderTableView: UITableViewHeaderFooterView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var categoriesScrollView: UIScrollView!
    @IBOutlet weak var categoriesStackView: UIStackView!
    static let reuseIdentifier = "HeaderID"
    weak var delegate: HeaderDelegate?    
    func addImageView(imgName: String) {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 112).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.image = UIImage(named: imgName)
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        self.stackView.addArrangedSubview(imageView)
    }
    func addButton(name: String) {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.widthAnchor.constraint(equalToConstant: 88).isActive = true
        button.setTitle(name, for: .normal)
//        button.titleLabel?.font = UIFont(name: "System", size: 13)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.clipsToBounds = true
        button.layer.borderColor = UIColor(red: 253 / 256,
                                           green: 58 / 256,
                                           blue: 105 / 256,
                                           alpha: 0.4).cgColor
        button.setTitleColor(UIColor(red: 253 / 256,
                                     green: 58 / 256,
                                     blue: 105 / 256,
                                     alpha: 0.4),
                             for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.categoriesStackView.addArrangedSubview(button)
    }
    @objc func buttonAction(sender: UIButton!) {
      print("Button tapped")
    }
}
