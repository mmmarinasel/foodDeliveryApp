import UIKit

class PictureCollectionViewCell: UICollectionViewCell {
    private var imageView: UIImageView?
    
    func setImage(_ image: UIImage?) {
        if self.imageView == nil {
            self.imageView = UIImageView(frame: CGRect(x: 0,
                                                       y: 0,
                                                       width: self.contentView.frame.width,
                                                       height: self.contentView.frame.height))
            if let imgView = self.imageView {
                self.contentView.addSubview(imgView)
            }
        }
        if image == nil {
            let defaultImage = UIImage(named: "placeholder-image")
            self.imageView?.image = defaultImage
        } else {
            self.imageView?.image = image
        }
    }
}
