import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBAction func editPhotoActionButton(_ sender: Any) {
        buildPhotoAlert()
    }
    
    @IBAction func saveHandleButton(_ sender: Any) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileImageView.setRounded()
//        self.view.addSubview(self.nameLabel)
    }
    
    private func buildPhotoAlert() {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let cameraButton = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self?.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let photoLibraryButton = UIAlertAction(title: "Photo libraby", style: .default) { [weak self] _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                self?.present(imagePicker, animated: true, completion: nil)
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(cameraButton)
        alert.addAction(photoLibraryButton)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
    }
}

extension UIImageView {
    func setRounded() {
          let radius = CGRectGetWidth(self.frame) / 2
          self.layer.cornerRadius = radius
          self.layer.masksToBounds = true
       }
}
