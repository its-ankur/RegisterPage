import UIKit

class GenderSegmentCell: UITableViewCell {

    @IBOutlet weak var GenderSegment: UISegmentedControl!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    // Closure to handle gender selection changes
    var onGenderChanged: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Hide the error label by default
        ErrorLabel.isHidden = true
        
        // Add target to handle selection change in segmented control
        GenderSegment.addTarget(self, action: #selector(genderChanged(_:)), for: .valueChanged)
    }

    @objc func genderChanged(_ sender: UISegmentedControl) {
        // Notify the parent view controller when gender selection changes
        onGenderChanged?(sender.selectedSegmentIndex)
    }
    
    // Method to display or hide the error label
    func showError(_ message: String?) {
        if let errorMessage = message {
            ErrorLabel.text = errorMessage
            ErrorLabel.isHidden = false
        } else {
            ErrorLabel.isHidden = true
        }
    }
    
    // Method to set the selected segment programmatically
    func setSelectedGender(index: Int) {
        GenderSegment.selectedSegmentIndex = index
    }
}
