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
        save()
    }
    
    private let datePicker = UIDatePicker()
    
    private lazy var profileModel: ProfileModel = {
        var model = ProfileModel()
        return model
    }()
    
    private var repeatNeeded: Bool = false
//    private var profileData: ProfileData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImageView.setRounded()
        self.saveButton.setRoundedBounds()
        
        showDatePicker()
        
        self.phoneNumberTextField.delegate = self
        
        self.profileModel.load { [weak self] data in
//            self?.profileData = data
            self?.updateUI(profileData: data)
        }
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
    
    func updateUI(profileData: ProfileData) {
        guard profileData.name != nil && profileData.phoneNumber != nil else { return }
        DispatchQueue.main.async {
            self.nameTextField.text = profileData.name
            self.phoneNumberTextField.text = profileData.phoneNumber
        }
        if profileData.birthday != nil {
            DispatchQueue.main.async {
                self.birthdayTextField.text = profileData.birthday
            }
        } else if profileData.email != nil {
            DispatchQueue.main.async {
                self.emailTextField.text = profileData.email
            }
        }
    }
    
    func handleSave(_ errors: [Error]) {
        DispatchQueue.main.sync {
            if !errors.isEmpty {
                buildFailedSaveAlert()
            } else {
                buildSuccessefulSaveAlert()
            }
        }
        if self.repeatNeeded {
            self.repeatNeeded = false
            self.save()
        }
    }
    
    func save() {
        if self.nameTextField.text != "", self.phoneNumberTextField.text != "" {
            var profileData = ProfileData(name: self.nameTextField.text,
                                          birthday: self.birthdayTextField.text,
                                          email: self.emailTextField.text,
                                          phoneNumber: self.phoneNumberTextField.text)
            self.profileModel.save(profileData: profileData) { [weak self] errors in
                self?.handleSave(errors)
            }
            print("SAVED SAVED SAVED")
        } else {
            buildErrorAlert()
        }
    }
    
    func buildSuccessefulSaveAlert() {
        let alert = UIAlertController(title: "Saved successefully",
                                      message: nil,
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok",
                                     style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    func buildFailedSaveAlert() {
        let alert = UIAlertController(title: "Error",
                                      message: "Failed to save data",
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok",
                                     style: .default)
        let repeatButton = UIAlertAction(title: "Repeat",
                                         style: .cancel) { [weak self] _ in
            self?.repeatNeeded = true
        }
        alert.addAction(repeatButton)
        alert.addAction(okButton)
        present(alert, animated: true)
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
