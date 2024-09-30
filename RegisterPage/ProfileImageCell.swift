import UIKit

class ProfileImageCell: UITableViewCell {

    @IBOutlet weak var PersonImage: UIImageView!
    @IBOutlet weak var CameraImage: UIImageView!
    
    // Declare a closure for handling image selection (to communicate with the view controller)
    var onImageTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Round the profile image (to look like a circle)
        PersonImage.layer.cornerRadius = PersonImage.frame.size.width / 2
        PersonImage.clipsToBounds = true
        
        // Set up a tap gesture recognizer for both PersonImage and CameraImage
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        PersonImage.isUserInteractionEnabled = true
        PersonImage.addGestureRecognizer(tapGesture)
        
        let cameraTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        CameraImage.isUserInteractionEnabled = true
        CameraImage.addGestureRecognizer(cameraTapGesture)
    }

    @objc func imageTapped() {
        // Call the closure when image is tapped
        onImageTapped?()
    }
    
    // Method to set the selected profile image
    func setupProfileImage(image: UIImage?) {
        if let profileImage = image {
            PersonImage.image = profileImage
        } else {
            PersonImage.image = UIImage(named: "defaultProfileImage") // Set a default image
        }
    }
}

