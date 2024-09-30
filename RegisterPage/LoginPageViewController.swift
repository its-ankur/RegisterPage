//
//  LoginPageViewController.swift
//  RegisterPage
//
//  Created by Ankur on 23/09/24.
//

import UIKit
import CryptoKit

class LoginPageViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var LoginBtn: UIButton!
    @IBOutlet weak var RegisterPageBtn: UIButton!
    
    // MARK: - Error Labels
    var emailErrorLabel: UILabel!
    var passwordErrorLabel: UILabel!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize Database
        DatabaseHelper.shared.initializeDatabase()
        
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
            navigateToUserDetailsPage()
        }
        else{
            setupUI()
            setupTapGesture()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backgroundColor=nil
    }

    
    private func navigateToUserDetailsPage() {
        if let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfilePage") as? ProfilePage {
            navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }

    
    // MARK: - UI Setup
    private func setupUI() {
        // Initialize error labels
        setupErrorLabels()
        
        // Add separators below text fields
        addSeparatorBelow(view: Email)
        addSeparatorBelow(view: Password)
        
        // Set initial placeholder colors
        setPlaceholderColor(for: Email, color: UIColor.lightGray)
        setPlaceholderColor(for: Password, color: UIColor.lightGray)
        
        // Set delegates
        Email.delegate = self
        Password.delegate = self
        
        // Add target actions for real-time validation
        Email.addTarget(self, action: #selector(emailEditingChanged(_:)), for: .editingChanged)
        Password.addTarget(self, action: #selector(passwordEditingChanged(_:)), for: .editingChanged)
        
        // Enable password toggle for Password field
        Password.enablePasswordToggle()
        
        // Set initial secure text entry
        Password.isSecureTextEntry = true
        
        // Initialize Database (Assuming DatabaseHelper is correctly implemented)
        DatabaseHelper.shared.initializeDatabase()
        
        // Style the Login Button
        LoginBtn.layer.cornerRadius = 5
        LoginBtn.clipsToBounds = true
        
        // Style the Register Button
        RegisterPageBtn.layer.cornerRadius = 5
        RegisterPageBtn.clipsToBounds = true
    }
    
    // Function to setup error labels
    func setupErrorLabels() {
        // Create error labels
        emailErrorLabel = createErrorLabel()
        passwordErrorLabel = createErrorLabel()
        
        // Add labels to the view
        self.view.addSubview(emailErrorLabel)
        self.view.addSubview(passwordErrorLabel)
        
        // Set up constraints for the error labels
        NSLayoutConstraint.activate([
            emailErrorLabel.leadingAnchor.constraint(equalTo: Email.leadingAnchor),
            emailErrorLabel.topAnchor.constraint(equalTo: Email.bottomAnchor, constant: 2),
            emailErrorLabel.trailingAnchor.constraint(equalTo: Email.trailingAnchor),
            
            passwordErrorLabel.leadingAnchor.constraint(equalTo: Password.leadingAnchor),
            passwordErrorLabel.topAnchor.constraint(equalTo: Password.bottomAnchor, constant: 2),
            passwordErrorLabel.trailingAnchor.constraint(equalTo: Password.trailingAnchor),
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
    
    // Function to add a separator (horizontal line) below any UIView (including UITextField)
    func addSeparatorBelow(view: UIView, color: UIColor = UIColor.lightGray, thickness: CGFloat = 1, margin: CGFloat = 0) {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = color
        
        // Add separator to the view hierarchy
        self.view.addSubview(separator)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: thickness),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            separator.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0) // Directly below the text field
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

    
    // MARK: - Validation Methods
    
    // Email Validation
    func validateEmail() {
        guard let email = Email.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty else {
            showError(label: emailErrorLabel, message: "Email is required", for: Email)
            return
        }
        
        if !isValidEmail(email) {
            showError(label: emailErrorLabel, message: "Enter a valid email address", for: Email)
        } else {
            hideError(label: emailErrorLabel, for: Email)
        }
    }
    
    // Password Validation
    func validatePassword() {
        guard let password = Password.text, !password.isEmpty else {
            showError(label: passwordErrorLabel, message: "Password is required", for: Password)
            return
        }
        
        if !isValidPassword(password) {
            showError(label: passwordErrorLabel, message: "Password must be at least 6 characters", for: Password)
        } else {
            hideError(label: passwordErrorLabel, for: Password)
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func LoginBtnClicked(_ sender: UIButton) {
        print("Login button clicked")
        
        // Perform validations
        validateEmail()
        validatePassword()
        
        // Check if there are no validation errors
        let isLoginFormValid = emailErrorLabel.isHidden && passwordErrorLabel.isHidden
        
        if isLoginFormValid {
            // Unwrap and handle optional values
            guard let email = Email.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let password = Password.text, !password.isEmpty else {
                // This should not happen due to prior validations
                return
            }
            
            // Hash the password before checking
            let hashedPassword = hashPassword(password)
            
            // Check if user exists in the database and password matches
            if let user = DatabaseHelper.shared.fetchUser(byEmail: email) {
                if user.password == hashedPassword {
                    // Save login status to UserDefaults
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(true, forKey: "isUserLoggedIn")

                    userDefaults.set(email, forKey: "Email")
                    
                    // Show success toast message
                    CustomToast.showToast(message: "Login Successful!", inView: self.view, backgroundColor: UIColor.systemGreen)
                    
                    resetForm()
                    
                    // Navigate to the Details Page
                    if let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfilePage") as? ProfilePage {

                        navigationController?.pushViewController(detailsViewController, animated: true)
                    }
                } else {
                    // Incorrect password
                    showError(label: passwordErrorLabel, message: "Incorrect password", for: Password)
                    // Optionally, show a toast message
                    CustomToast.showToast(message: "Incorrect password. Please try again.", inView: self.view, backgroundColor: UIColor.systemRed)
                }
            } else {
                // User not found
                showError(label: emailErrorLabel, message: "User not found. Please register first.", for: Email)
                // Optionally, show a toast message
                CustomToast.showToast(message: "User not found. Please register first.", inView: self.view, backgroundColor: UIColor.systemRed)
            }
        } else {
            // Show general error toast message
            CustomToast.showToast(message: "Please fix the errors before submitting.", inView: self.view, backgroundColor: UIColor.systemRed)
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        // Navigate to Register Page
        print("Register Here tapped")
        if let registerVC = storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            self.navigationController?.pushViewController(registerVC, animated: true)
        }
    }
    
    // MARK: - Helper Methods
    
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
    
    // Function to reset the form (optional)
    func resetForm() {
        Email.text = ""
        Password.text = ""
        
        // Clear error labels
        hideError(label: emailErrorLabel, for: Email)
        hideError(label: passwordErrorLabel, for: Password)
        
        // Reset placeholder colors
        setPlaceholderColor(for: Email, color: UIColor.lightGray)
        setPlaceholderColor(for: Password, color: UIColor.lightGray)
    }
    
    // Function to hash password using SHA256
    func hashPassword(_ password: String) -> String {
        // Simple hashing using SHA256
        if let data = password.data(using: .utf8) {
            let hashed = SHA256.hash(data: data)
            return hashed.compactMap { String(format: "%02x", $0) }.joined()
        }
        return password
    }
    
    // MARK: - Selector Methods for Real-Time Validation
    
    @objc func emailEditingChanged(_ textField: UITextField) {
        validateEmail()
    }
    
    @objc func passwordEditingChanged(_ textField: UITextField) {
        validatePassword()
    }
    
    // MARK: - Keyboard Dismissal
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        // Optionally, set cancelsTouchesInView to false to allow other interactions
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Utility Validation Functions
    
    /// Validates if the provided email string is in a correct format.
    /// - Parameter email: The email string to validate.
    /// - Returns: A Boolean indicating whether the email is valid.
    func isValidEmail(_ email: String) -> Bool {
        // Regular expression for email validation
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    /// Validates if the provided password meets the required criteria.
    /// - Parameter password: The password string to validate.
    /// - Returns: A Boolean indicating whether the password is valid.
    func isValidPassword(_ password: String) -> Bool {
        // Password criteria:
        // Minimum 6 characters, at least one uppercase, one lowercase, one digit, one special character (@, &, $, ^)
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@&\\$\\^]).{6,}$"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPredicate.evaluate(with: password)
    }
    
}
