import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBAction func editPhotoActionButton(_ sender: Any) {
        buildPhotoAlert()
    }
    
    @IBAction func saveHandleButton(_ sender: Any) {
//        if let name = self.nameTextField.text, let number = self.phoneNumberTextField.text {
        if self.nameTextField.text != "", self.phoneNumberTextField.text != "" {
            self.profileData = ProfileData(name: self.nameTextField.text,
                                           birthday: self.birthdayTextField.text,
                                           email: self.emailTextField.text,
                                           phoneNumber: self.phoneNumberTextField.text)
            print("SAVED SAVED SAVED")
        } else {
            buildErrorAlert()
        }
    }
    
    let datePicker = UIDatePicker()
    private var profileData: ProfileData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImageView.setRounded()
        self.saveButton.setRoundedBounds()
        
        showDatePicker()
        
        self.phoneNumberTextField.delegate = self
    }
    
    private func buildErrorAlert() {
        let alert = UIAlertController(title: "You have to enter your name and phone number",
                                      message: nil,
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .destructive)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    private func buildPhotoAlert() {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let cameraButton = UIAlertAction(title: "Camera",
                                         style: .default) { [weak self] _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self?.present(imagePicker, animated: true, completion: nil)
            }
        }
        let photoLibraryButton = UIAlertAction(title: "Photo libraby",
                                               style: .default) { [weak self] _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                self?.present(imagePicker, animated: true, completion: nil)
            }
        }
        let networkButton = UIAlertAction(title: "Upload from network",
                                          style: .default) { [weak self] _ in
            let vc = PicturesViewController()
            vc.delegate = self
//            vc.modalPresentationStyle = .popover
            self?.present(vc, animated: true)
        }
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .destructive,
                                         handler: nil)
        alert.addAction(cameraButton)
        alert.addAction(photoLibraryButton)
        alert.addAction(networkButton)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.profileImageView.image = image
        dismiss(animated: true)
    }
    
    func showDatePicker() {
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .plain,
                                         target: self,
                                         action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                          target: nil,
                                          action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel",
                                           style: .plain,
                                           target: self,
                                           action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton, spaceButton, cancelButton],
                         animated: false)
        self.birthdayTextField.inputAccessoryView = toolbar
        self.birthdayTextField.inputView = self.datePicker
    }
    
    @objc func donedatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        self.birthdayTextField.text = formatter.string(from: self.datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true   )
    }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]",
                                                 with: "",
                                                 options: .regularExpression)
        var result: String = ""
        var index = numbers.startIndex
        
        for char in mask where index < numbers.endIndex {
            if char == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(char)
            }
        }
        
        return result
    }
}

extension ProfileViewController: IPicturePickable {
    func handlePicturePicked(image: UIImage) {
        self.profileImageView.image = image
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: "+X (XXX) XXX-XXXX", phone: newString)
        return false
    }
}

extension UIImageView {
    
    func setRounded() {
          let radius = CGRectGetWidth(self.frame) / 2
          self.layer.cornerRadius = radius
          self.layer.masksToBounds = true
       }
}

extension UIButton {
    func setRoundedBounds() {
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(red: 166 / 255,
                                         green: 205 / 255,
                                         blue: 142 / 255,
                                         alpha: 1).cgColor
    }
}
