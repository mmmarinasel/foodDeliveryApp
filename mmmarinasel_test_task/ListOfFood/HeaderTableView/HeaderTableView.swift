import UIKit

class HeaderTableView: UITableViewHeaderFooterView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var categoriesScrollView: UIScrollView!
    @IBOutlet weak var categoriesStackView: UIStackView!
    
    static let reuseIdentifier = "HeaderID"

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
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.clipsToBounds = true
        button.layer.borderColor = UIColor(red: 154 / 256,
                                           green: 212 / 256,
                                           blue: 215 / 256,
                                           alpha: 1).cgColor
        button.setTitleColor(UIColor(red: 241 / 256,
                                     green: 186 / 256,
                                     blue: 226 / 256,
                                     alpha: 1),
                             for: .normal)
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.categoriesStackView.addArrangedSubview(button)
    }
    
    @objc func buttonAction(sender: UIButton!) {
      print("Button tapped")
    }
}
