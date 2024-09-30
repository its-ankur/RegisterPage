import UIKit

class FormFields: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var ItemError: UILabel!
    @IBOutlet weak var FormItem: UITextField!
    @IBOutlet weak var calendarIcon: UIImageView!
    
    private var countryPicker: UIPickerView!
    private var countries: [String] = ["USA", "Canada", "UK", "India", "Australia"]
    
    // Create a date formatter
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // Change to your preferred style
        formatter.dateFormat = "dd/MM/yyyy" // Set your desired format
        return formatter
    }()
    
    var selectedCountry: String? {
        didSet {
            FormItem.text = selectedCountry
        }
    }
    
    // Property to check if this is a country cell
    var isCountryCell: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add a tap gesture recognizer to the form item
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(formItemTapped(_:)))
        FormItem.addGestureRecognizer(tapGesture)
    }
    
    @objc func formItemTapped(_ sender: UITapGestureRecognizer) {
        // Only show country picker if this is a country cell
        if isCountryCell {
            setupCountryPicker()
            showCountryPicker()
        } else {
            FormItem.becomeFirstResponder() // Allow editing for other fields
        }
    }
    
    // Function to setup country picker for the Country text field
    private func setupCountryPicker() {
        countryPicker = UIPickerView()
        countryPicker.delegate = self
        countryPicker.dataSource = self
        FormItem.inputView = countryPicker // This will only apply for the country cell
        FormItem.delegate = self
        
        // Add a toolbar with a Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePickingCountry))
        toolbar.setItems([doneButton], animated: true)
        FormItem.inputAccessoryView = toolbar
    }
    
    @objc func donePickingCountry() {
        FormItem.resignFirstResponder() // Dismiss the picker
    }

    // MARK: - UIPickerView DataSource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }

    // MARK: - UIPickerView Delegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = countries[row]
    }
    
    func showCountryPicker() {
        FormItem.becomeFirstResponder() // Show the picker
    }
    
    func configureCell(forType type: String) {
        print(type)
        if type == "Country" {
            isCountryCell = true // Mark this cell as the country cell
            FormItem.placeholder = "Select Country"
            ItemError.isHidden = false
            ItemError.text = "Country is required"
            FormItem.inputView = countryPicker // Set the input view only for country
            calendarIcon.isHidden = false
            calendarIcon.image = UIImage(named: "Cross")
            calendarIcon.isUserInteractionEnabled = true
            // Add tap gesture to calendar icon
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(crossTapped(_:)))
            calendarIcon.addGestureRecognizer(tapGesture)
        } else if type == "DateOfBirth" {
            isCountryCell = false
            FormItem.placeholder = "Date of Birth"
            ItemError.isHidden = true
            FormItem.inputView = nil // No input view for DateOfBirth
            calendarIcon.isHidden = false // Show the calendar icon
            
            // Set the calendar icon image
            calendarIcon.image = UIImage(named: "Calender") // Use your actual asset name here
            calendarIcon.isUserInteractionEnabled = true
            
            // Add tap gesture to calendar icon
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(calendarIconTapped(_:)))
            calendarIcon.addGestureRecognizer(tapGesture)
        } else {
            isCountryCell = false // Mark this cell as not the country cell
            FormItem.placeholder = "Enter \(type)"
            ItemError.isHidden = true
            FormItem.inputView = nil // Ensure no input view is set for other fields
            calendarIcon.isHidden = true // Hide the icon for other fields
        }
    }
    
    // Handle calendar icon tap
    @objc func calendarIconTapped(_ sender: UITapGestureRecognizer) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        FormItem.inputView = datePicker // Set date picker as input view
        FormItem.inputAccessoryView = createToolbar(selector: #selector(donePickingDate)) // Add toolbar with Done button
        FormItem.becomeFirstResponder() // Show the date picker
    }
    
    // Create a toolbar for the date picker
    private func createToolbar(selector: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePickingDate))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, doneButton], animated: false)
        
        return toolbar
    }
    
    // Handle date change
    @objc func dateChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" // Set your desired format here
        
        // Set the formatted date in the DateOfBirth text field
        FormItem.text = dateFormatter.string(from: selectedDate)
    }
    
    @objc func donePickingDate() {
        FormItem.resignFirstResponder() // Dismiss the date picker
    }
    
    // Handle cross icon tap
    @objc func crossTapped(_ sender: UITapGestureRecognizer) {
        FormItem.text = ""
    }
}

