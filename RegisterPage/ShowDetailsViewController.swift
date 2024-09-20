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
}


