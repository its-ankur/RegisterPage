//import Foundation
//import UIKit
//
//class ProfilePage: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
//
//    @IBOutlet weak var tableView: UITableView!
//    
//    // User information variables
//    var firstName: String = ""
//    var lastName: String = ""
//    var email: String = ""
//    var contactNumber: String = ""
//    var dateOfBirth: String = ""
//    var country: String = ""
//    var gender: String = ""
//    var changePassword: Bool = false
//    var password: String = ""
//    var confirmPassword: String = ""
//    
//    // Store the selected gender index
//       var selectedGenderIndex: Int = 0
//       var genderError: String?
//    
//    var activeTextField: UITextField?
//    var validationErrors: [String?] = Array(repeating: nil, count: 6) // Assuming 6 form fields in the form
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Register Nibs/Cells
//        let formNib = UINib(nibName: "FormFields", bundle: nil)
//        let profileImageNib = UINib(nibName: "ProfileImageCell", bundle: nil)
//        let genderSegmentNib = UINib(nibName: "GenderSegmentCell", bundle: nil)
//        let changePasswordNib = UINib(nibName: "ChangePasswordCell", bundle: nil)
//        let updateNib = UINib(nibName: "UpdateButtonCell", bundle: nil)
//        
//        tableView.register(formNib, forCellReuseIdentifier: "FormFields")
//        tableView.register(profileImageNib, forCellReuseIdentifier: "ProfileImageCell")
//        tableView.register(genderSegmentNib, forCellReuseIdentifier: "GenderSegmentCell")
//        tableView.register(changePasswordNib, forCellReuseIdentifier: "ChangePasswordCell")
//        tableView.register(updateNib, forCellReuseIdentifier: "UpdateButtonCell")
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        
//        // Remove separator lines
//            tableView.separatorStyle = .none
//
//        
//        // Prefill user data
//        fetchUserData()
//        
//        // Disable back button
//        self.navigationItem.hidesBackButton = true
//        
//        // Set the navigation bar's appearance
//                let appearance = UINavigationBarAppearance()
//        appearance.configureWithTransparentBackground() // Use opaque background for solid color
//                
//                
//                // Apply the appearance to the navigation bar
//                navigationController?.navigationBar.standardAppearance = appearance
//                navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        
//        // Set the navigation bar's background to be completely clear
//                navigationController?.navigationBar.backgroundColor = .clear
//                navigationController?.navigationBar.isTranslucent = true // Make it translucent
//
//        // Add tap gesture recognizer
//               let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//               view.addGestureRecognizer(tapGesture)
//        
//        // Register for keyboard notifications
//                  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//                  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//        
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true) // Dismiss the keyboard
//    }
//    
//    deinit {
//        // Unregister from notifications
//        NotificationCenter.default.removeObserver(self)
//    }
//    
//    
//    
//    
//    
//    // MARK: - Fetch User Data
//    func fetchUserData() {
//        let userDefaults = UserDefaults.standard
//        let savedEmail = userDefaults.string(forKey: "Email") ?? ""
//        
//        if let user = DatabaseHelper.shared.fetchUser(byEmail: savedEmail) {
//            // Set user information
//            self.firstName = user.firstName
//            self.lastName = user.lastName ?? ""
//            self.email = user.email
//            self.contactNumber = user.contactNumber ?? ""
//            self.dateOfBirth = user.dateOfBirth ?? ""
//            self.country = user.country ?? ""
//            self.gender = user.gender
//        }
//        
//        // Reload the table to show prefilled data
//        tableView.reloadData()
//    }
//    
//    // MARK: - Table View Data Source
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 5 // Profile Image, User Info, Gender, Change Password
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return 1  // Profile Image
//        case 1:
//            return 6  // FirstName, LastName, Email, Contact, DateOfBirth
//        case 2:
//            return 1  // Gender Segment Control
//        case 3:
//            return changePassword ? 3 : 1// ChangePassword switch, Password fields (if switch is on)
//        case 4:
//            return 1
//        default:
//            return 0
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case 0: // Profile Image Section
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageCell
//            
//            // Set the current profile image if available
//            let profileImage = UIImage(named: "Person") // Fetch from your source
//            cell.setupProfileImage(image: profileImage)
//            
//            // Define the closure to handle image tap
//            cell.onImageTapped = {
//                self.showImagePickerOptions()
//            }
//            
//            return cell
//            
//        case 1: // User Info Section
//            let cell = tableView.dequeueReusableCell(withIdentifier: "FormFields", for: indexPath) as! FormFields
//            cell.FormItem.delegate = self // Set delegate for the text field
//            
//            switch indexPath.row {
//            case 0:
//                cell.FormItem.placeholder = "First Name *"
//                cell.FormItem.text = firstName
//                cell.ItemError.text = "First name is required"
//                cell.ItemError.isHidden = true
//            
//                
//            case 1:
//                cell.FormItem.placeholder = "Last Name"
//                cell.FormItem.text = lastName
////                cell.ItemError.text = "Last name is required"
//                cell.ItemError.isHidden = true
//                
//            case 2:
//                cell.FormItem.placeholder = "Email *"
//                cell.FormItem.isUserInteractionEnabled = false // Disable editing for email
//                cell.FormItem.text = email
//                cell.ItemError.isHidden = true
//                //cell.ItemError.text = "Email is required"
//                
//            case 3:
//                cell.FormItem.placeholder = "Contact Number"
//                cell.FormItem.text = contactNumber
//                //cell.ItemError.text = "Contact is required"
//                cell.ItemError.isHidden = true
//                
//            case 4:
//                cell.FormItem.placeholder = "Date of Birth"
//                cell.configureCell(forType: "DateOfBirth")
//                cell.FormItem.text = dateOfBirth
//                //cell.ItemError.text = "Date of birth is required"
//                cell.ItemError.isHidden = true
//                
//            case 5:
//                cell.configureCell(forType: "Country") // Call the method to configure the cell specifically for country
//                cell.FormItem.text = country
//                //cell.ItemError.text = "Country is required"
//                cell.ItemError.isHidden = true
//                
//            default:
//                break
//            }
//            return cell
//            
//        case 2: // Gender Segment Section
//            let cell = tableView.dequeueReusableCell(withIdentifier: "GenderSegmentCell", for: indexPath) as! GenderSegmentCell
//            
//            // Set the previously selected gender
//            cell.setSelectedGender(index: selectedGenderIndex)
//            
//            // Handle gender selection changes
//            cell.onGenderChanged = { [weak self] selectedIndex in
//                self?.selectedGenderIndex = selectedIndex
//                self?.validateGender() // Call validation method after gender change
//            }
//            
//            // Display any validation error
//            cell.showError(genderError)
//            
//            return cell
//            
//        case 3: // Change Password Section
//            if indexPath.row == 0 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "ChangePasswordCell", for: indexPath) as! ChangePasswordCell
//                cell.ChangeSwitch.isOn = changePassword
//                cell.ChangeSwitch.addTarget(self, action: #selector(changePasswordToggled(_:)), for: .valueChanged)
//                return cell
//            } else if indexPath.row == 1 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "FormFields", for: indexPath) as! FormFields
//                cell.FormItem.placeholder = "New Password *"
//                cell.FormItem.isSecureTextEntry = true
//                cell.ItemError.text = "New Password is required"
//                cell.ItemError.isHidden = true
//                return cell
//            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "FormFields", for: indexPath) as! FormFields
//                cell.FormItem.placeholder = "Confirm Password *"
//                cell.FormItem.isSecureTextEntry = true
//                cell.ItemError.text = "Confirm Password is required"
//                cell.ItemError.isHidden = true
//                return cell
//            }
//            
//        case 4:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateButtonCell", for: indexPath) as! UpdateButtonCell
//            cell.UpdateButton.addTarget(self, action: #selector(updateClicked(_:)), for: .touchUpInside)
//            return cell
//            
//        default:
//            return UITableViewCell()
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Clicked")
//        print(indexPath.row)
//    }
//
//    
//    // MARK: - Table View Delegate
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//        case 0:
//            return 120  // Profile Image
//        case 1:
//            return 80  // FirstName, LastName, Email, Contact, DateOfBirth
//        case 2:
//            return 80  // Gender Segment Control
//        case 3:
//            return 80 // ChangePassword switch, Password fields (optional)
//        default:
//            return 60
//        }
//    }
//    
//    // MARK: - Update cell values on text change
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let cell = textField.superview?.superview as? UITableViewCell,
//           let indexPath = tableView.indexPath(for: cell) {
//            switch indexPath.section {
//            case 1:
//                switch indexPath.row {
//                case 0:
//                    firstName = textField.text ?? ""
//                case 1:
//                    lastName = textField.text ?? ""
//                case 3:
//                    contactNumber = textField.text ?? ""
//                case 4:
//                    dateOfBirth = textField.text ?? ""
//                default:
//                    break
//                }
//            case 3:
//                if indexPath.row == 1 {
//                    password = textField.text ?? ""
//                } else if indexPath.row == 2 {
//                    confirmPassword = textField.text ?? ""
//                }
//            default:
//                break
//            }
//        }
//    }
//    
//    // MARK: - Actions
//    
//    @objc func changePasswordToggled(_ sender: UISwitch) {
//        changePassword = sender.isOn
//        tableView.reloadSections([3], with: .automatic)
//    }
//    
//    @objc func updateClicked(_ sender: UISwitch){
//        if validateForm() {
//            saveUserProfile()
//        } else {
//            // Show validation errors
//            print("Validation failed.")
//        }
//    }
//    
//    func validateForm() -> Bool {
//            var isValid = true
//            
//            // Validate FirstName
//            if firstName.isEmpty {
//                validationErrors[0] = "First name is required"
//                isValid = false
//            } else {
//                validationErrors[0] = nil
//            }
//            
//            // Validate Email
//            if email.isEmpty || !isValidEmail(email) {
//                validationErrors[1] = "Valid email is required"
//                isValid = false
//            } else {
//                validationErrors[1] = nil
//            }
//            
//            // Validate Contact
//            if !contactNumber.isEmpty && !isValidPhoneNumber(contactNumber) {
//                validationErrors[2] = "Valid contact number is required"
//                isValid = false
//            } else {
//                validationErrors[2] = nil
//            }
//            
//            // Validate Date of Birth (Optional but if entered must be valid)
//            if !dateOfBirth.isEmpty && !isValidDateOfBirth(dateOfBirth) {
//                validationErrors[3] = "Valid date of birth is required"
//                isValid = false
//            } else {
//                validationErrors[3] = nil
//            }
//            
//            // Validate Password (If ChangePassword is enabled)
//            if changePassword {
//                if password.isEmpty || confirmPassword.isEmpty {
//                    validationErrors[4] = "Both password fields are required"
//                    isValid = false
//                } else if password != confirmPassword {
//                    validationErrors[4] = "Passwords do not match"
//                    isValid = false
//                } else {
//                    validationErrors[4] = nil
//                }
//            }
//            
//            return isValid
//        }
//    
//
//    
//    // MARK: - Validation & Save Logic
//    
//    func validateFields() -> Bool {
//        var isValid = true
//        
//        if !validateFirstName() {
//            isValid = false
//        }
//        
//        if !validateLastName() {
//            isValid = false
//        }
//        
//        if !validateContactNumber() {
//            isValid = false
//        }
//        
//        if !validateDateOfBirth() {
//            isValid = false
//        }
//        
//        if !validateCountry() {
//            isValid = false
//        }
//        
//        if changePassword && !validatePasswords() {
//            isValid = false
//        }
//        
//        return isValid
//    }
//    
//    func validateFirstName() -> Bool {
//        if firstName.isEmpty {
//            showError(forRow: 0, message: "First Name is required")
//            return false
//        } else {
//            hideError(forRow: 0)
//            return true
//        }
//    }
//
//    func validateLastName() -> Bool {
//        if lastName.isEmpty {
//            showError(forRow: 1, message: "Last Name is required")
//            return false
//        } else {
//            hideError(forRow: 1)
//            return true
//        }
//    }
//
//    func validateContactNumber() -> Bool {
//        if contactNumber.isEmpty || !isValidPhoneNumber(contactNumber) {
//            showError(forRow: 3, message: "Valid contact number is required")
//            return false
//        } else {
//            hideError(forRow: 3)
//            return true
//        }
//    }
//
//    func validateDateOfBirth() -> Bool {
//        if !dateOfBirth.isEmpty && !isValidDateOfBirth(dateOfBirth) {
//            showError(forRow: 4, message: "Valid date of birth is required (18+)")
//            return false
//        } else {
//            hideError(forRow: 4)
//            return true
//        }
//    }
//
//    func validateCountry() -> Bool {
//        if country.isEmpty {
//            showError(forRow: 5, message: "Country is required")
//            return false
//        } else {
//            hideError(forRow: 5)
//            return true
//        }
//    }
//
//    func validatePasswords() -> Bool {
//        if password.isEmpty {
//            showError(forSection: 3, row: 1, message: "New password is required")
//            return false
//        }
//        
//        if password != confirmPassword {
//            showError(forSection: 3, row: 2, message: "Passwords do not match")
//            return false
//        }
//        
//        hideError(forSection: 3, row: 1)
//        hideError(forSection: 3, row: 2)
//        return true
//    }
//
//    func showError(forRow row: Int, message: String) {
//        let indexPath = IndexPath(row: row, section: 1) // Section 1 is for user info fields
//        if let cell = tableView.cellForRow(at: indexPath) as? FormFields {
//            cell.ItemError.isHidden = false
//            cell.ItemError.text = message
//        }
//    }
//
//    func showError(forSection section: Int, row: Int, message: String) {
//        let indexPath = IndexPath(row: row, section: section)
//        if let cell = tableView.cellForRow(at: indexPath) as? FormFields {
//            cell.ItemError.isHidden = false
//            cell.ItemError.text = message
//        }
//    }
//
//    func hideError(forRow row: Int) {
//        let indexPath = IndexPath(row: row, section: 1)
//        if let cell = tableView.cellForRow(at: indexPath) as? FormFields {
//            cell.ItemError.isHidden = true
//        }
//    }
//
//    func hideError(forSection section: Int, row: Int) {
//        let indexPath = IndexPath(row: row, section: section)
//        if let cell = tableView.cellForRow(at: indexPath) as? FormFields {
//            cell.ItemError.isHidden = true
//        }
//    }
//
//    func isValidPhoneNumber(_ number: String) -> Bool {
//        let phoneRegex = "^[0-9]{10}$"
//        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
//        return phoneTest.evaluate(with: number)
//    }
//
//    func isValidDateOfBirth(_ dob: String) -> Bool {
//        // Add logic to check if the user is 18+ years old
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyyy" // Or your preferred format
//        
//        if let birthDate = dateFormatter.date(from: dob) {
//            let now = Date()
//            let ageComponents = Calendar.current.dateComponents([.year], from: birthDate, to: now)
//            let age = ageComponents.year ?? 0
//            return age >= 18
//        }
//        
//        return false
//    }
//
//    
//    func saveUserProfile() {
//        // Create a User object with the provided details
//            let user = User(
//                firstName: firstName,
//                lastName: lastName,
//                email: email,
//                contactNumber: contactNumber,
//                password: password,
//                dateOfBirth: dateOfBirth,
//                gender: gender,
//                country: country,
//                termsAccepted: true // Assuming termsAccepted is true
//            )
//            
//            // Save the profile data into SQLite using DatabaseHelper and update UserDefaults
//            let success = DatabaseHelper.shared.updateUserProfile(user: user, forEmail: email)
//            
//            if success {
//                print("Profile updated successfully!")
//                // Optionally, show a success toast or an alert
//            } else {
//                print("Failed to update profile.")
//            }
//    }
//    
//    // MARK: - Image Picker Logic
//        
//        func showImagePickerOptions() {
//            let actionSheet = UIAlertController(title: "Select Image", message: "Choose a photo from your library or take a new one", preferredStyle: .actionSheet)
//            
//            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
//                self.openCamera()
//            }))
//            
//            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
//                self.openPhotoLibrary()
//            }))
//            
//            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            
//            self.present(actionSheet, animated: true, completion: nil)
//        }
//        
//        func openCamera() {
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                let imagePicker = UIImagePickerController()
//                imagePicker.delegate = self
//                imagePicker.sourceType = .camera
//                self.present(imagePicker, animated: true, completion: nil)
//            } else {
//                print("Camera not available")
//            }
//        }
//        
//        func openPhotoLibrary() {
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = .photoLibrary
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//        
//        // MARK: - UIImagePickerControllerDelegate
//        
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                // Update the profile image in the cell
//                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileImageCell
//                cell?.setupProfileImage(image: selectedImage)
//            }
//            picker.dismiss(animated: true, completion: nil)
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            picker.dismiss(animated: true, completion: nil)
//        }
//    
//    func validateGender() {
//            // Example validation logic
//            if selectedGenderIndex == -1 {
//                genderError = "Please select a gender."
//            } else {
//                genderError = nil
//            }
//            
//            // Reload the gender section to show/hide the error label
//            tableView.reloadSections(IndexSet(integer: 1), with: .none)
//        }
//
//    // MARK: - Table View Delegate
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0 // Remove header spacing
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0 // Remove footer spacing
//    }
//
//    @IBAction func LogOutClicked(_ sender: UIButton) {
//        print("Logout button clicked")
//        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
//                self.logout()
//            }))
//            present(alert, animated: true, completion: nil)
//
//    }
//    
//    func logout() {
//        // Clear user session data
//        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
//        UserDefaults.standard.removeObject(forKey: "Email")
//        
//        
//        // Show logged out message and navigate back to the login screen
//        CustomToast.showToast(message: "Logged out successfully.", inView: view.self, backgroundColor: UIColor.systemGreen)
//        
//        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginPageViewController") as! LoginPageViewController
//        navigationController?.setViewControllers([loginVC], animated: true)
//    }
//
//    // Method to dismiss the keyboard
//        @objc func dismissKeyboard() {
//            view.endEditing(true) // Hides the keyboard
//        }
//    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        guard let userInfo = notification.userInfo,
//                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//            
//            let keyboardHeight = keyboardFrame.cgRectValue.height
//            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
//        tableView.contentInset = contentInsets
//        tableView.scrollIndicatorInsets = contentInsets
//            
//            if let activeField = activeTextField {
//                let aRect = self.view.frame
//                if !aRect.contains(activeField.frame.origin) {
//                    tableView.scrollRectToVisible(activeField.frame, animated: true)
//                }
//            }
//
//    }
//    
//    @objc func keyboardWillHide(notification: NSNotification) {
//        // Reset the content inset when the keyboard is hidden
//        let contentInsets = UIEdgeInsets.zero
//        tableView.contentInset = contentInsets
//        tableView.scrollIndicatorInsets = contentInsets
//    }
//
//    func isValidEmail(_ email: String) -> Bool {
//        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
//        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
//        return emailTest.evaluate(with: email)
//    }
//
//        
//    
//}
//
//
//extension ProfilePage {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // Determine which cell the text field belongs to
//        if let cell = textField.superview?.superview as? UITableViewCell,
//           let indexPath = tableView.indexPath(for: cell) {
//            switch indexPath.section {
//            case 1: // User Info Section
//                switch indexPath.row {
//                case 0: // First Name
//                    updateValue(for: &firstName, textField: textField, range: range, replacementString: string)
//                case 1: // Last Name
//                    updateValue(for: &lastName, textField: textField, range: range, replacementString: string)
//                case 3: // Contact Number
//                    updateValue(for: &contactNumber, textField: textField, range: range, replacementString: string)
//                case 4: // Date of Birth
//                    updateValue(for: &dateOfBirth, textField: textField, range: range, replacementString: string)
//                default:
//                    break
//                }
//            case 3: // Change Password Section
//                if indexPath.row == 1 { // New Password
//                    updateValue(for: &password, textField: textField, range: range, replacementString: string)
//                } else if indexPath.row == 2 { // Confirm Password
//                    updateValue(for: &confirmPassword, textField: textField, range: range, replacementString: string)
//                }
//            default:
//                break
//            }
//        }
//        return true // Allow the change to happen
//    }
//
//    private func updateValue(for variable: inout String, textField: UITextField, range: NSRange, replacementString string: String) {
//        // Get the current text in the text field
//        let currentText = textField.text ?? ""
//        
//        // Calculate the new text value
//        guard let stringRange = Range(range, in: currentText) else { return }
//        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//        
//        // Update the respective variable
//        variable = updatedText
//        
//        // Print the updated variable for debugging
//        print("Updated variable: \(variable) for text field: \(textField.placeholder ?? "Unknown")")
//    }
//}






import UIKit
import CryptoKit

class ProfilePage: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var ConfirmPasswordView: UIView!
    @IBOutlet weak var PasswordView: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var Update: UIButton!
    @IBOutlet weak var ConfirmPassword: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var ChangeSwitch: UISwitch!
    @IBOutlet weak var Gender: UISegmentedControl!
    @IBOutlet weak var Cross: UIButton!
    @IBOutlet weak var Country: UITextField!
    @IBOutlet weak var Calender: UIButton!
    @IBOutlet weak var DateOfBirth: UITextField!
    @IBOutlet weak var Contact: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var FirstName: UITextField!
    
    // MARK: - Error Labels
    var firstNameErrorLabel: UILabel!
    var emailErrorLabel: UILabel!
    var genderErrorLabel: UILabel!
    var passwordErrorLabel: UILabel!
    var confirmPassErrorLabel: UILabel!
    var termsErrorLabel: UILabel!
    var countryErrorLabel: UILabel!
    var dateOfBirthErrorLabel: UILabel!
    var contactErrorLabel: UILabel!

    // MARK: - Picker View
    var countryPicker: UIPickerView!
    var activeTextField: UITextField?
    let countries = ["USA", "Canada", "UK", "India", "Australia"]
    
    // Create a date formatter
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium // Change to your preferred style
            formatter.dateFormat = "dd/MM/yyyy" // Set your desired format
            return formatter
        }()

    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.systemOrange
        
        // Initialize error labels
        setupErrorLabels()
        
        // Add horizontal rules (lines) below each text field or view
        addSeparatorBelow(view: FirstName)
        addSeparatorBelow(view: LastName)
        addSeparatorBelow(view: Email)
        addSeparatorBelow(view: Contact)
        addSeparatorBelow(view: DateOfBirth)
        addSeparatorBelow(view: Country)
        addSeparatorBelow(view: Password)
        addSeparatorBelow(view: ConfirmPassword)
        
        // Set initial placeholder colors
        setPlaceholderColor(for: FirstName, color: UIColor.lightGray)
        setPlaceholderColor(for: LastName, color: UIColor.lightGray)
        setPlaceholderColor(for: Email, color: UIColor.lightGray)
        setPlaceholderColor(for: Contact, color: UIColor.lightGray)
        setPlaceholderColor(for: DateOfBirth, color: UIColor.lightGray)
        setPlaceholderColor(for: Country, color: UIColor.lightGray)
        setPlaceholderColor(for: Password, color: UIColor.lightGray)
        setPlaceholderColor(for: ConfirmPassword, color: UIColor.lightGray)
        
        // Setup country picker
        setupCountryPicker()
        
        // Set delegates
        FirstName.delegate = self
        LastName.delegate = self
        Email.delegate = self
        Contact.delegate = self
        DateOfBirth.delegate = self
        Country.delegate = self
        Password.delegate = self
        ConfirmPassword.delegate = self
        
        // Add target actions
        ChangeSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        
        // Initialize Database
        DatabaseHelper.shared.initializeDatabase()

        // Add action to date picker
        Calender.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

        // **Enable password toggle for Password and ConfirmPass fields**
        Password.enablePasswordToggle()
        ConfirmPassword.enablePasswordToggle()
        
        // Set initial secure text entry
//        Password.isSecureTextEntry = true
//        ConfirmPassword.isSecureTextEntry = true
        
        // **Add targets for real-time validation on Password and Confirm Password fields**
        Password.addTarget(self, action: #selector(passwordEditingChanged(_:)), for: .editingChanged)
        ConfirmPassword.addTarget(self, action: #selector(confirmPassEditingChanged(_:)), for: .editingChanged)
        
        // **Add targets for real-time validation on Contact and DateOfBirth fields**
            Contact.addTarget(self, action: #selector(contactEditingChanged(_:)), for: .editingChanged)
            DateOfBirth.addTarget(self, action: #selector(dateOfBirthEditingChanged(_:)), for: .editingChanged)
        
        Contact.keyboardType = .numberPad

        // Add tap gesture recognizer
               let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
               view.addGestureRecognizer(tapGesture)
        
        // Register for keyboard notifications
                  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Customize the title color for this view controller
//        self.navigationController?.navigationBar.backgroundColor = [
//                    NSAttributedString.Key.backgroundColor: UIColor.systemOrange // Set the title color to red
//                ]
        
        // Fetch user data from the database and display it in the text fields
            fetchUserData()
        // Hide the back button
            self.navigationItem.hidesBackButton = true
        
        PasswordView.isHidden = !ChangeSwitch.isOn
        ConfirmPasswordView.isHidden = !ChangeSwitch.isOn
        
    }
    
    // Function to fetch user data from the database
    func fetchUserData() {
        // Assuming you have a method in your DatabaseHelper to get the user data
        
        // Retrieve saved user details from UserDefaults
            let userDefaults = UserDefaults.standard
            let savedEmail = userDefaults.string(forKey: "Email") ?? ""
        
        if let userData = DatabaseHelper.shared.fetchUser(byEmail: savedEmail ) {
            // Update the text fields with the fetched data
            FirstName.text = userData.firstName
            LastName.text = userData.lastName
            Email.text = userData.email
            Contact.text = userData.contactNumber
            DateOfBirth.text = userData.dateOfBirth // Use the appropriate date format
            if userData.gender == "Male" {
                Gender.selectedSegmentIndex=0
            }
            else if userData.gender == "Female" {
                Gender.selectedSegmentIndex=1
            }
            else{
                Gender.selectedSegmentIndex=2
            }
            Country.text = userData.country // Assuming country is already populated using the country picker

            // Hide any error labels since data has been populated
            hideError(label: firstNameErrorLabel, for: FirstName)
            hideError(label: emailErrorLabel, for: Email)
            hideError(label: contactErrorLabel, for: Contact)
            hideError(label: dateOfBirthErrorLabel, for: DateOfBirth)
            hideError(label: countryErrorLabel, for: Country)
            hideError(label: passwordErrorLabel, for: Password)
            hideError(label: confirmPassErrorLabel, for: ConfirmPassword)
        } else {
            // Handle the case where no user data is found (e.g., show a message or reset fields)
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true) // Dismiss the keyboard
    }

    
    deinit {
        // Unregister from notifications
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup Functions
    
    // Function to setup error labels
    func setupErrorLabels() {
        // Create error labels
        firstNameErrorLabel = createErrorLabel()
        emailErrorLabel = createErrorLabel()
        passwordErrorLabel = createErrorLabel()
        confirmPassErrorLabel = createErrorLabel()
        countryErrorLabel = createErrorLabel()
        dateOfBirthErrorLabel = createErrorLabel()
        contactErrorLabel = createErrorLabel()
        
        // Add labels to the view
        self.view.addSubview(firstNameErrorLabel)
        self.view.addSubview(emailErrorLabel)
        self.view.addSubview(passwordErrorLabel)
        self.view.addSubview(confirmPassErrorLabel)
        self.view.addSubview(countryErrorLabel)
        self.view.addSubview(dateOfBirthErrorLabel)
        self.view.addSubview(contactErrorLabel)
        
        // Set up constraints for the error labels
        NSLayoutConstraint.activate([
            firstNameErrorLabel.leadingAnchor.constraint(equalTo: FirstName.leadingAnchor),
            firstNameErrorLabel.topAnchor.constraint(equalTo: FirstName.bottomAnchor, constant: 2),
            firstNameErrorLabel.trailingAnchor.constraint(equalTo: FirstName.trailingAnchor),
            
            emailErrorLabel.leadingAnchor.constraint(equalTo: Email.leadingAnchor),
            emailErrorLabel.topAnchor.constraint(equalTo: Email.bottomAnchor, constant: 2),
            emailErrorLabel.trailingAnchor.constraint(equalTo: Email.trailingAnchor),
            
            contactErrorLabel.leadingAnchor.constraint(equalTo: Contact.leadingAnchor),
            contactErrorLabel.topAnchor.constraint(equalTo: Contact.bottomAnchor, constant: 2),
            contactErrorLabel.trailingAnchor.constraint(equalTo: Contact.trailingAnchor),
            
            dateOfBirthErrorLabel.leadingAnchor.constraint(equalTo: DateOfBirth.leadingAnchor),
            dateOfBirthErrorLabel.topAnchor.constraint(equalTo: DateOfBirth.bottomAnchor, constant: 2),
            dateOfBirthErrorLabel.trailingAnchor.constraint(equalTo: DateOfBirth.trailingAnchor),
            
            
            
            passwordErrorLabel.leadingAnchor.constraint(equalTo: Password.leadingAnchor),
            passwordErrorLabel.topAnchor.constraint(equalTo: Password.bottomAnchor, constant: 2),
            passwordErrorLabel.trailingAnchor.constraint(equalTo: Password.trailingAnchor),
            
            confirmPassErrorLabel.leadingAnchor.constraint(equalTo: ConfirmPassword.leadingAnchor),
            confirmPassErrorLabel.topAnchor.constraint(equalTo: ConfirmPassword.bottomAnchor, constant: 2),
            confirmPassErrorLabel.trailingAnchor.constraint(equalTo: ConfirmPassword.trailingAnchor),
            
        ])
    }
    
    // Function to create a standardized error label
    func createErrorLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.systemRed
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.isHidden = true // Initially hidden
        return label
    }
    
    // Function to add a separator (horizontal rule) below any UIView (including UITextField)
    func addSeparatorBelow(view: UIView, color: UIColor = UIColor.lightGray, thickness: CGFloat = 1, margin: CGFloat = 0) {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = color
        
        // Add separator to the view
        self.view.addSubview(separator)
        
        // Set up constraints with customizable margin and thickness
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: thickness),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            separator.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)  // Add some spacing
        ])
    }
    
    // Function to set placeholder color
    func setPlaceholderColor(for textField: UITextField, color: UIColor) {
        let placeholderText = textField.placeholder ?? ""
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    }
    
    // Function to setup country picker for the Country text field
    func setupCountryPicker() {
        countryPicker = UIPickerView()
        countryPicker.delegate = self
        countryPicker.dataSource = self
        Country.inputView = countryPicker
        Country.delegate = self
        
        // Add a toolbar with a Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePickingCountry))
        toolbar.setItems([doneButton], animated: false)
        Country.inputAccessoryView = toolbar
    }
    
    @objc func donePickingCountry() {
        Country.resignFirstResponder() // Dismiss the picker
    }
    
    // MARK: - Picker View DataSource & Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Country.text = countries[row]
        hideError(label: countryErrorLabel, for: Country)
    }
    
    // MARK: - TextField Delegate Methods

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Handle real-time validation based on the text field
        if textField == FirstName {
            validateFirstName()
        } else if textField == Email {
            validateEmail()
        } else if textField == Contact {
            // Real-time validation for Contact commented out
        } else if textField == DateOfBirth {
            // Handle DateOfBirth as a text input without DatePicker
                                    let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                                    
                                    // Custom validation for date format (dd/MM/yyyy)
                                    if newText.count <= 10 { // Limit input to 10 characters (dd/MM/yyyy)
                                        // Allow numbers and '/'
                                        let allowedCharacters = CharacterSet(charactersIn: "0123456789/")
                                        let characterSet = CharacterSet(charactersIn: string)
                                        return allowedCharacters.isSuperset(of: characterSet)
                                    } else {
                                        // Prevent more than 10 characters from being entered
                                        return false
                                    }
        } else if textField == Country {
            //validateCountry()
            return false
        } else if textField == Password {
            validatePassword()
        } else if textField == ConfirmPassword {
            // Real-time validation for ConfirmPass is disabled
        }
        //textField.resignFirstResponder() // This will hide the keyboard

        // Allow text change to proceed for other fields
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField=nil
        // Perform validation once editing ends for the specific fields
        if textField == FirstName {
            validateFirstName()
        } else if textField == Email {
            validateEmail()
        } else if textField == Contact {
            // Validation after editing ends
        } else if textField == DateOfBirth {
            // Validate the date format when editing ends
            if !isValidDateFormat(textField.text!) {
                // Handle invalid date format (e.g., show an error message)
                showInvalidDateFormatMessage()
            }
        } else if textField == Country {
            //validateCountry()
        } else if textField == Password {
            validatePassword()
        } else if textField == ConfirmPassword {
            // Real-time validation for ConfirmPass is disabled
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            activeTextField = textField // Track the active text field
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder() // Hide the keyboard
            return true
        }
    
    // Helper method to validate date format (dd/MM/yyyy)
    func isValidDateFormat(_ dateText: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: dateText) != nil
    }

    // Helper method to show an invalid date format message
    func showInvalidDateFormatMessage() {
        // Implement your custom error message here, e.g., an alert or inline label
        print("Invalid date format. Please enter the date in DD/MM/YYYY format.")
    }
    
    // MARK: - Validation Functions
    
    func validateFirstName() {
        if let firstName = FirstName.text, firstName.trimmingCharacters(in: .whitespaces).isEmpty {
            showError(label: firstNameErrorLabel, message: "First Name is required", for: FirstName)
        } else {
            hideError(label: firstNameErrorLabel, for: FirstName)
        }
    }
    
    func validateEmail() {
        if let email = Email.text, email.trimmingCharacters(in: .whitespaces).isEmpty {
            showError(label: emailErrorLabel, message: "Email is required", for: Email)
        } else if let email = Email.text, !isValidEmail(email) {
            showError(label: emailErrorLabel, message: "Enter a valid email address", for: Email)
        } else {
            hideError(label: emailErrorLabel, for: Email)
        }
    }

    
    func validatePassword() {
        if let password = Password.text, password.isEmpty {
            showError(label: passwordErrorLabel, message: "Password is required", for: Password)
        } else if let password = Password.text, !isValidPassword(password) {
            showError(label: passwordErrorLabel, message: "Password must be at least 6 characters, include uppercase, lowercase, digit, and special character (@, &, $, ^)", for: Password)
        } else {
            hideError(label: passwordErrorLabel, for: Password)
        }
    }
    
    func validateConfirmPassword() {
        guard let password = Password.text, !password.isEmpty else {
            // If Password field is empty, prompt the user to enter it first
            showError(label: passwordErrorLabel, message: "Password is required", for: Password)
            return
        }
        
        guard let confirmPass = ConfirmPassword.text, !confirmPass.isEmpty else {
            showError(label: confirmPassErrorLabel, message: "Confirm Password is required", for: ConfirmPassword)
            return
        }
        
        if password != confirmPass {
            showError(label: confirmPassErrorLabel, message: "Passwords do not match", for: ConfirmPassword)
        } else {
            hideError(label: confirmPassErrorLabel, for: ConfirmPassword)
        }
    }
    
    func validateSwitch() {
        if !ChangeSwitch.isOn {
//            showError(label: termsErrorLabel, message: "Please accept terms and conditions", for: ChangeSwitch)
        } else {
//            hideError(label: termsErrorLabel, for: ChangeSwitch)
        }
    }
    
    func validateCountry() {
        if let country = Country.text, !country.isEmpty {
            hideError(label: countryErrorLabel, for: Country)
        }
    }
    
    func validateDateOfBirth() {
        // Check if the DateOfBirth text is empty; if so, skip validation
        guard let dobText = DateOfBirth.text, !dobText.isEmpty else {
            // Clear any existing error if the field is left empty
            hideError(label: dateOfBirthErrorLabel, for: DateOfBirth)
            return
        }
        
        // Attempt to parse the date if not empty
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" // Ensure this matches your DatePicker's format
        guard let dateOfBirth = dateFormatter.date(from: dobText) else {
            showError(label: dateOfBirthErrorLabel, message: "Invalid date format", for: DateOfBirth)
            return
        }
        
        // Calculate age
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: now)
        
        if let age = ageComponents.year, age < 18 {
            showError(label: dateOfBirthErrorLabel, message: "You must be at least 18 years old", for: DateOfBirth)
            return
        }
        
        // If all validations pass
        hideError(label: dateOfBirthErrorLabel, for: DateOfBirth)
    }


    
    func validateContact() {
        guard let contact = Contact.text, !contact.isEmpty else {
            hideError(label: contactErrorLabel, for: Contact)
            return
        }
        
        // Check if contact contains only digits
        let digitsCharacterSet = CharacterSet.decimalDigits
        if contact.rangeOfCharacter(from: digitsCharacterSet.inverted) != nil {
            showError(label: contactErrorLabel, message: "Contact number must contain only digits", for: Contact)
            return
        }
        
        // Check if contact has exactly 10 digits
        if contact.count != 10 {
            showError(label: contactErrorLabel, message: "Contact number must be exactly 10 digits", for: Contact)
            return
        }
        
        // If all validations pass
        hideError(label: contactErrorLabel, for: Contact)
    }

    
    // MARK: - Utility Validation Functions
    
    func isValidEmail(_ email: String) -> Bool {
        // Regular expression for email validation
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        // Password criteria:
        // Minimum 6 characters, at least one uppercase, one lowercase, one digit, one special character (@, &, $, ^)
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@&\\$\\^]).{6,}$"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPredicate.evaluate(with: password)
    }
    
    func isValidAge(_ dob: String) -> Bool {
        // Assuming dob is in "dd/MM/yyyy" format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        guard let dateOfBirth = dateFormatter.date(from: dob) else { return false }
        
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: now)
        if let age = ageComponents.year, age >= 18 {
            return true
        }
        return false
    }
    
    func isValidContact(_ contact: String) -> Bool {
        // Simple validation: check if contact is numeric and 10 digits
        let contactRegEx = "^[0-9]{10}$"
        let contactPredicate = NSPredicate(format:"SELF MATCHES %@", contactRegEx)
        return contactPredicate.evaluate(with: contact)
    }
    
    // MARK: - Error Handling
    
    // Function to show an error message for a specific field
    func showError(label: UILabel, message: String, for textField: UITextField) {
        label.text = message
        label.isHidden = false
        setPlaceholderColor(for: textField, color: UIColor.red)
    }
    
    // Function to hide the error message
    func hideError(label: UILabel, for textField: UITextField) {
        label.isHidden = true
        label.text = ""
        setPlaceholderColor(for: textField, color: UIColor.lightGray)
    }
    
    @IBAction func CrossBtn(_ sender: UIButton) {
        Country.text=""
    }
    
    
    @IBAction func DateBtn(_ sender: UIButton) {
        // Create an alert controller
        let alert = UIAlertController(title: "Select Date of Birth", message: nil, preferredStyle: .alert)
        
        // Create and configure the date picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        // Set a maximum date (optional) to ensure user is at least 18 years old
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        
        // Add the date picker to the alert
        alert.view.addSubview(datePicker)
        
        // Set constraints for the date picker with 10 points of padding
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 20).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -20).isActive = true
        datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 50).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        // Create and add actions
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            // Set the date format to dd/MM/yyyy
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy" // Set your desired format here
            
            // Set the formatted date in the DateOfBirth text field
            self.DateOfBirth.text = dateFormatter.string(from: datePicker.date)
        }))
        
        // Adjust the alert view width and height with padding
        let widthConstraint = NSLayoutConstraint(item: alert.view!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320) // Adjust width to account for padding
        let heightConstraint = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300) // Adjust height
        alert.view.addConstraint(widthConstraint)
        alert.view.addConstraint(heightConstraint)
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func UpdateBtn(_ sender: UIButton) {
        print("Update button clicked")
            
            // Perform validations before proceeding
            validateFirstName()
            validateEmail()
            validatePassword()
            validateConfirmPassword()
            validateSwitch()
            
            // Check if there are no validation errors
            let isFormValid = firstNameErrorLabel.isHidden &&
                emailErrorLabel.isHidden &&
                passwordErrorLabel.isHidden &&
                confirmPassErrorLabel.isHidden &&
                dateOfBirthErrorLabel.isHidden &&
                contactErrorLabel.isHidden
            
            if isFormValid {
                // Retrieve text field values
                guard let firstName = FirstName.text?.trimmingCharacters(in: .whitespaces),
                      let email = Email.text?.trimmingCharacters(in: .whitespaces) else {
                    CustomToast.showToast(message: "Please fill in all required fields.", inView: self.view, backgroundColor: UIColor.systemRed)
                    return
                }
                
                let lastName = LastName.text?.trimmingCharacters(in: .whitespaces) ?? ""
                let contact = Contact.text?.trimmingCharacters(in: .whitespaces)
                let dateOfBirth = DateOfBirth.text?.trimmingCharacters(in: .whitespaces)
                let genderIndex = Gender.selectedSegmentIndex
                let genderString = genderIndex == UISegmentedControl.noSegment ? "" : Gender.titleForSegment(at: genderIndex)!
                let country = Country.text?.trimmingCharacters(in: .whitespaces)
                let password = Password.text!

                // Hash the password before updating
                let hashedPassword = hashPassword(password)
                
                // Create a user object with the new data
                let user = User(
                    firstName: firstName,
                    lastName: lastName.isEmpty ? nil : lastName,
                    email: email,
                    contactNumber: contact,
                    password: hashedPassword, // Use the hashed password
                    dateOfBirth: dateOfBirth,
                    gender: genderString,
                    country: country,
                    termsAccepted: true // Or set based on your terms acceptance logic
                )
                
                // Update user details in SQLite database
                let updateSuccess = DatabaseHelper.shared.updateUserProfile(user: user, forEmail: email)
                
                if updateSuccess {
                    // Show success toast message
                    CustomToast.showToast(message: "Update Successful!", inView: self.view, backgroundColor: UIColor.systemGreen)
                    // Optionally, refresh the UI or navigate to another view
                } else {
                    // Show error toast message
                    CustomToast.showToast(message: "Update Failed! Please try again.", inView: self.view, backgroundColor: UIColor.systemRed)
                }
            } else {
                // Show general error toast message
                CustomToast.showToast(message: "Please fix the errors before submitting.", inView: self.view, backgroundColor: UIColor.systemRed)
            }
    }
    
    
    @IBAction func ChangeSwitchToggled(_ sender: UISwitch) {
        if sender.isOn {
                // Show password fields
            PasswordView.isHidden = false
            ConfirmPasswordView.isHidden = false
            } else {
                // Hide password fields
                PasswordView.isHidden = true
                ConfirmPasswordView.isHidden = true
            }
        // Update the layout
            self.view.layoutIfNeeded()
    }
    
    func hashPassword(_ password: String) -> String {
        // Simple hashing using SHA256
        if let data = password.data(using: .utf8) {
            let hashed = SHA256.hash(data: data)
            return hashed.compactMap { String(format: "%02x", $0) }.joined()
        }
        return password
    }
    
    
    @objc func switchValueChanged(){
        validateSwitch()
    }
    
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        // Set the formatted date in the text field
        DateOfBirth.text = formatDateToString(date: sender.date)
    }
    
    @objc func passwordEditingChanged(_ textField: UITextField) {
        validateConfirmPassword()
    }
    
    @objc func confirmPassEditingChanged(_ textField: UITextField) {
        validateConfirmPassword()
    }
    
    // Selector for Contact field changes
    @objc func contactEditingChanged(_ textField: UITextField) {
        validateContact()
    }

    // Selector for DateOfBirth field changes
    @objc func dateOfBirthEditingChanged(_ textField: UITextField) {
        validateDateOfBirth()
    }

    // Method to dismiss the keyboard
        @objc func dismissKeyboard() {
            view.endEditing(true) // Hides the keyboard
        }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        ScrollView.contentInset = contentInsets
        ScrollView.scrollIndicatorInsets = contentInsets
            
            if let activeField = activeTextField {
                let aRect = self.view.frame
                if !aRect.contains(activeField.frame.origin) {
                    ScrollView.scrollRectToVisible(activeField.frame, animated: true)
                }
            }

    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // Reset the content inset when the keyboard is hidden
        let contentInsets = UIEdgeInsets.zero
        ScrollView.contentInset = contentInsets
        ScrollView.scrollIndicatorInsets = contentInsets
    }
    
    // Format date to "dd/MM/yyyy"
        func formatDateToString(date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: date)
        }

    
}
