import UIKit

class ShowDetailsViewController: UIViewController {

    @IBOutlet weak var EmailShow: UITextField!
    @IBOutlet weak var GenderShow: UITextField!
    @IBOutlet weak var CountryShow: UITextField!
    @IBOutlet weak var PageTitle: UILabel!

    let genders = ["Male", "Female", "Other"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the back button color
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        // Hide the back button
        self.navigationItem.hidesBackButton = true
        
        // Retrieve saved user details from UserDefaults
        let userDefaults = UserDefaults.standard
        let savedEmail = userDefaults.string(forKey: "Email") ?? ""
        
        // Fetch user details from SQLite database
        let userDetails = DatabaseHelper.shared.fetchUser(byEmail: savedEmail)
        print(userDetails)
        
        // Safely unwrap userDetails
        if let details = userDetails {
            let firstName = details.firstName
            let lastName = details.lastName ?? "" // Optional field
            let country = details.country ?? "" // Optional field
            let gender = details.gender ?? "" // Optional field
            
            // Set default values if needed
            let title = "Hi, \(firstName) \(lastName.isEmpty ? "" : lastName)"
            let displayCountry = country.isEmpty ? "Not Specified" : country
            let displayGender = (gender.isEmpty || !genders.contains(gender)) ? "Not Specified" : gender
            
            print("\(firstName) \(lastName)")
            
            EmailShow.text = savedEmail
            CountryShow.text = displayCountry
            GenderShow.text = displayGender
            PageTitle.text = title
        } else {
            // Handle the case where no user details were found
            EmailShow.text = ""
            CountryShow.text = "Not Specified"
            GenderShow.text = "Not Specified"
            PageTitle.text = "User Not Found"
        }
        
        // Make the text fields non-editable
        EmailShow.isEnabled = false
        GenderShow.isEnabled = false
        CountryShow.isEnabled = false
    }
    
    // Back button action
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
                self.logout()
            }))
            present(alert, animated: true, completion: nil)
    }
    
    func logout() {
        // Clear user session data
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.removeObject(forKey: "Email")
        
        
        // Show logged out message and navigate back to the login screen
        CustomToast.showToast(message: "Logged out successfully.", inView: view.self, backgroundColor: UIColor.systemGreen)
        
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginPageViewController") as! LoginPageViewController
        navigationController?.setViewControllers([loginVC], animated: true)
    }
    
}


