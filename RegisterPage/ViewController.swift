import UIKit
import CryptoKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // Outlets for UI components
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var SwitchText: UITextField!
    @IBOutlet weak var GenderText: UITextField!
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var Gender: UISegmentedControl!
    @IBOutlet weak var SwitchStack: UIStackView!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var ConfirmPass: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var GenderStack: UIStackView!
    @IBOutlet weak var GenderView: UIView!
    @IBOutlet weak var Country: UITextField!
    @IBOutlet weak var DateOfBirth: UITextField!
    @IBOutlet weak var Contact: UITextField!
    @IBOutlet weak var RegisterButton: UIButton!
    
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
    let countries = ["USA", "Canada", "UK", "India", "Australia"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize error labels
        setupErrorLabels()
        
        // Add horizontal rules (lines) below each text field or view
        addSeparatorBelow(view: FirstName)
        addSeparatorBelow(view: LastName)
        addSeparatorBelow(view: Email)
        addSeparatorBelow(view: Contact)
        addSeparatorBelow(view: DateOfBirth)
        addSeparatorBelow(view: Country)
        addSeparatorBelow(view: GenderView)
        addSeparatorBelow(view: Password)
        addSeparatorBelow(view: ConfirmPass)
        
        // Set initial placeholder colors
        setPlaceholderColor(for: FirstName, color: UIColor.lightGray)
        setPlaceholderColor(for: LastName, color: UIColor.lightGray)
        setPlaceholderColor(for: Email, color: UIColor.lightGray)
        setPlaceholderColor(for: Contact, color: UIColor.lightGray)
        setPlaceholderColor(for: DateOfBirth, color: UIColor.lightGray)
        setPlaceholderColor(for: Country, color: UIColor.lightGray)
        setPlaceholderColor(for: Password, color: UIColor.lightGray)
        setPlaceholderColor(for: ConfirmPass, color: UIColor.lightGray)
        
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
        ConfirmPass.delegate = self
        
        // **Set Gender segmented control to have no segment selected by default**
        Gender.selectedSegmentIndex = UISegmentedControl.noSegment
        
        // Add target actions
        Switch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        Gender.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        
        // Initialize Database
        DatabaseHelper.shared.initializeDatabase()
        
        // Set DatePicker mode
        DatePicker.datePickerMode = .date
        
        // Add action to date picker
        DatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        // **Enable password toggle for Password and ConfirmPass fields**
        Password.enablePasswordToggle()
        ConfirmPass.enablePasswordToggle()
        
        // Set initial secure text entry
        Password.isSecureTextEntry = true
        ConfirmPass.isSecureTextEntry = true
        
        // **Add targets for real-time validation on Password and Confirm Password fields**
        Password.addTarget(self, action: #selector(passwordEditingChanged(_:)), for: .editingChanged)
        ConfirmPass.addTarget(self, action: #selector(confirmPassEditingChanged(_:)), for: .editingChanged)
        
        // **Add targets for real-time validation on Contact and DateOfBirth fields**
            Contact.addTarget(self, action: #selector(contactEditingChanged(_:)), for: .editingChanged)
            DateOfBirth.addTarget(self, action: #selector(dateOfBirthEditingChanged(_:)), for: .editingChanged)
    }
    
    // MARK: - Setup Functions
    
    // Function to setup error labels
    func setupErrorLabels() {
        // Create error labels
        firstNameErrorLabel = createErrorLabel()
        emailErrorLabel = createErrorLabel()
        genderErrorLabel = createErrorLabel()
        passwordErrorLabel = createErrorLabel()
        confirmPassErrorLabel = createErrorLabel()
        termsErrorLabel = createErrorLabel()
        countryErrorLabel = createErrorLabel()
        dateOfBirthErrorLabel = createErrorLabel()
        contactErrorLabel = createErrorLabel()
        
        // Add labels to the view
        self.view.addSubview(firstNameErrorLabel)
        self.view.addSubview(emailErrorLabel)
        self.view.addSubview(genderErrorLabel)
        self.view.addSubview(passwordErrorLabel)
        self.view.addSubview(confirmPassErrorLabel)
        self.view.addSubview(termsErrorLabel)
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
            
            countryErrorLabel.leadingAnchor.constraint(equalTo: Country.leadingAnchor),
            countryErrorLabel.topAnchor.constraint(equalTo: Country.bottomAnchor, constant: 2),
            countryErrorLabel.trailingAnchor.constraint(equalTo: Country.trailingAnchor),
            
            genderErrorLabel.leadingAnchor.constraint(equalTo: Gender.leadingAnchor),
            genderErrorLabel.topAnchor.constraint(equalTo: Gender.bottomAnchor, constant: 7),
            genderErrorLabel.trailingAnchor.constraint(equalTo: Gender.trailingAnchor),
            
            passwordErrorLabel.leadingAnchor.constraint(equalTo: Password.leadingAnchor),
            passwordErrorLabel.topAnchor.constraint(equalTo: Password.bottomAnchor, constant: 2),
            passwordErrorLabel.trailingAnchor.constraint(equalTo: Password.trailingAnchor),
            
            confirmPassErrorLabel.leadingAnchor.constraint(equalTo: ConfirmPass.leadingAnchor),
            confirmPassErrorLabel.topAnchor.constraint(equalTo: ConfirmPass.bottomAnchor, constant: 2),
            confirmPassErrorLabel.trailingAnchor.constraint(equalTo: ConfirmPass.trailingAnchor),
            
            termsErrorLabel.leadingAnchor.constraint(equalTo: Switch.leadingAnchor),
            termsErrorLabel.topAnchor.constraint(equalTo: Switch.bottomAnchor, constant: 2),
            termsErrorLabel.trailingAnchor.constraint(equalTo: Switch.trailingAnchor),
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
        if textField == FirstName {
            validateFirstName()
        } else if textField == Email {
            validateEmail()
        } else if textField == Contact {
//            validateContact()
        } else if textField == DateOfBirth {
//            validateDateOfBirth()
        } else if textField == Country {
            validateCountry()
        } else if textField == Password {
            validatePassword()
        } else if textField == ConfirmPass {
            // Removed real-time validation from delegate
            // validateConfirmPassword()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == FirstName {
            validateFirstName()
        } else if textField == Email {
            validateEmail()
        } else if textField == Contact {
            //validateContact()
        } else if textField == DateOfBirth {
            //validateDateOfBirth()
        } else if textField == Country {
            validateCountry()
        } else if textField == Password {
            validatePassword()
        } else if textField == ConfirmPass {
            // Removed real-time validation from delegate
            // validateConfirmPassword()
        }
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
    
    func validateGender() {
        if Gender.selectedSegmentIndex == UISegmentedControl.noSegment {
            showError(label: genderErrorLabel, message: "Please select a gender", for: GenderText)
        } else {
            hideError(label: genderErrorLabel, for: GenderText)
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
        
        guard let confirmPass = ConfirmPass.text, !confirmPass.isEmpty else {
            showError(label: confirmPassErrorLabel, message: "Confirm Password is required", for: ConfirmPass)
            return
        }
        
        if password != confirmPass {
            showError(label: confirmPassErrorLabel, message: "Passwords do not match", for: ConfirmPass)
        } else {
            hideError(label: confirmPassErrorLabel, for: ConfirmPass)
        }
    }
    
    func validateSwitch() {
        if !Switch.isOn {
            showError(label: termsErrorLabel, message: "Please accept terms and conditions", for: SwitchText)
        } else {
            hideError(label: termsErrorLabel, for: SwitchText)
        }
    }
    
    func validateCountry() {
        if let country = Country.text, !country.isEmpty {
            hideError(label: countryErrorLabel, for: Country)
        }
    }
    
    func validateDateOfBirth() {
        guard let dobText = DateOfBirth.text, !dobText.isEmpty else {
            showError(label: dateOfBirthErrorLabel, message: "Date of Birth is required", for: DateOfBirth)
            return
        }
        
        // Attempt to parse the date
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
            showError(label: contactErrorLabel, message: "Contact number is required", for: Contact)
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
    
    // MARK: - Button Actions
    
    @IBAction func BtnClicked(_ sender: UIButton) {
        print("Register button clicked")
        
        // Perform validations
        validateFirstName()
        validateEmail()
        validateGender()
        validatePassword()
        validateConfirmPassword()
        validateSwitch()
        validateDateOfBirth()
        validateContact()
        validateCountry()
        
        // Check if there are no validation errors
        let isFormValid = firstNameErrorLabel.isHidden &&
            emailErrorLabel.isHidden &&
            genderErrorLabel.isHidden &&
            passwordErrorLabel.isHidden &&
            confirmPassErrorLabel.isHidden &&
            termsErrorLabel.isHidden &&
            dateOfBirthErrorLabel.isHidden &&
            contactErrorLabel.isHidden &&
            countryErrorLabel.isHidden
        
        if isFormValid {
            // Unwrap and handle optional values
            let firstName = FirstName.text!.trimmingCharacters(in: .whitespaces)
            let lastName = LastName.text?.trimmingCharacters(in: .whitespaces) ?? ""
            let email = Email.text!.trimmingCharacters(in: .whitespaces)
            let contact = Contact.text?.trimmingCharacters(in: .whitespaces)
            let dateOfBirth = DateOfBirth.text?.trimmingCharacters(in: .whitespaces)
            let country = Country.text?.trimmingCharacters(in: .whitespaces)
            let genderIndex = Gender.selectedSegmentIndex
            let genderString = genderIndex == UISegmentedControl.noSegment ? "" : Gender.titleForSegment(at: genderIndex)!
            let password = Password.text!
            let termsAccepted = Switch.isOn
            
            // Hash the password before storing
            let hashedPassword = hashPassword(password)
            
            // Save user details to SQLite database
            let insertSuccess = DatabaseHelper.shared.insertUser(firstName: firstName, lastName: lastName, email: email, contactNumber: contact, password: hashedPassword, dateOfBirth: dateOfBirth, gender: genderString, country: country, termsAccepted: termsAccepted)
            
            if insertSuccess {
                // Save user details to UserDefaults (optional)
                let userDefaults = UserDefaults.standard
                userDefaults.set(email, forKey: "Email")
                
                // Show success toast message
                CustomToast.showToast(message: "Registration Successful!", inView: self.view, backgroundColor: UIColor.systemGreen)
                
                // Reset the form
                resetForm()
                
                // Navigate to ShowDetailsViewController
                if let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailsViewController") as? ShowDetailsViewController {
                    navigationController?.pushViewController(detailsViewController, animated: true)
                }
            } else {
                // Show error toast message
                CustomToast.showToast(message: "Registration Failed! Email might already be in use.", inView: self.view, backgroundColor: UIColor.systemRed)
            }
        } else {
            // Show general error toast message
            CustomToast.showToast(message: "Please fix the errors before submitting.", inView: self.view, backgroundColor: UIColor.systemRed)
        }
    }
    
    // MARK: - Helper Functions
    
    func resetForm() {
        FirstName.text = ""
        LastName.text = ""
        Email.text = ""
        Contact.text = ""
        DateOfBirth.text = ""
        Country.text = ""
        Password.text = ""
        ConfirmPass.text = ""
        Switch.isOn = false
        Gender.selectedSegmentIndex = UISegmentedControl.noSegment
        
        // Clear error labels
        hideError(label: firstNameErrorLabel, for: FirstName)
        hideError(label: emailErrorLabel, for: Email)
        hideError(label: genderErrorLabel, for: GenderText)
        hideError(label: passwordErrorLabel, for: Password)
        hideError(label: confirmPassErrorLabel, for: ConfirmPass)
        hideError(label: termsErrorLabel, for: SwitchText)
        hideError(label: countryErrorLabel, for: Country)
        hideError(label: dateOfBirthErrorLabel, for: DateOfBirth)
        hideError(label: contactErrorLabel, for: Contact)
        
        // Reset placeholder colors
        setPlaceholderColor(for: FirstName, color: UIColor.lightGray)
        setPlaceholderColor(for: LastName, color: UIColor.lightGray)
        setPlaceholderColor(for: Email, color: UIColor.lightGray)
        setPlaceholderColor(for: Contact, color: UIColor.lightGray)
        setPlaceholderColor(for: DateOfBirth, color: UIColor.lightGray)
        setPlaceholderColor(for: Country, color: UIColor.lightGray)
        setPlaceholderColor(for: Password, color: UIColor.lightGray)
        setPlaceholderColor(for: ConfirmPass, color: UIColor.lightGray)
    }
    
    func hashPassword(_ password: String) -> String {
        // Simple hashing using SHA256
        if let data = password.data(using: .utf8) {
            let hashed = SHA256.hash(data: data)
            return hashed.compactMap { String(format: "%02x", $0) }.joined()
        }
        return password
    }
    
    // MARK: - Selector Methods for Real-Time Validation
    
    @objc func passwordEditingChanged(_ textField: UITextField) {
        validateConfirmPassword()
    }
    
    @objc func confirmPassEditingChanged(_ textField: UITextField) {
        validateConfirmPassword()
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        // Create date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        // Set the formatted date in the text field
        DateOfBirth.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func switchValueChanged(){
        validateSwitch()
    }
    
    @objc func segmentValueChanged(){
        validateGender()
    }
    
    // Selector for Contact field changes
    @objc func contactEditingChanged(_ textField: UITextField) {
        validateContact()
    }

    // Selector for DateOfBirth field changes
    @objc func dateOfBirthEditingChanged(_ textField: UITextField) {
        validateDateOfBirth()
    }

    
}

// MARK: - SHA256 Extension

extension String {
    func sha256() -> String {
        let inputData = Data(self.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}

// MARK: - UITextField Extension for Password Toggle


extension UITextField {
    func enablePasswordToggle() {
        // Create a button and set its initial image
        let toggleButton = UIButton(type: .custom)
        toggleButton.setImage(UIImage(systemName: "eye"), for: .normal) // Eye icon for hidden password
        toggleButton.setImage(UIImage(systemName: "eye.slash"), for: .selected) // Eye slash for visible password
        toggleButton.tintColor = UIColor.gray
        toggleButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        // Add action to the button
        toggleButton.addTarget(self, action: #selector(togglePasswordView(_:)), for: .touchUpInside)
        
        // Assign the button to the rightView
        self.rightView = toggleButton
        self.rightViewMode = .always
    }
    
    @objc func togglePasswordView(_ sender: UIButton) {
        // Toggle the secure text entry
        self.isSecureTextEntry.toggle()
        
        // Update the button's selected state to change the icon
        sender.isSelected.toggle()
        
        // Preserve the current cursor position
        if let existingText = self.text, self.isFirstResponder {
            // Temporarily store the current selected text range
            let currentSelectedRange = self.selectedTextRange
            
            // Reassign the text to refresh the secure text entry
            self.text = existingText
            
            // Restore the selected text range
            self.selectedTextRange = currentSelectedRange
        }
    }
}

