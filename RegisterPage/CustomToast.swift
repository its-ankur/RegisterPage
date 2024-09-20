
import UIKit

class CustomToast {

    // Keep a reference to the current toast, so we can dismiss it if a new one appears
    private static var currentToast: UIView?

    // Function to show the toast message with a cross button and configurable background color
    static func showToast(message: String, inView view: UIView, backgroundColor: UIColor) {
        
        // If a toast is already visible, dismiss it before showing the new one
        if let activeToast = currentToast {
            dismissToast(toast: activeToast)
        }

        // Create a new toast container
        let toastContainer = UIView()
        toastContainer.backgroundColor = backgroundColor.withAlphaComponent(0.8)
        toastContainer.layer.cornerRadius = 10
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.numberOfLines = 0
        toastLabel.translatesAutoresizingMaskIntoConstraints = false

        let closeButton = UIButton(type: .custom)
        closeButton.setTitle("✖️", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(dismissToast(sender:)), for: .touchUpInside)

        // Add subviews to the container
        toastContainer.addSubview(toastLabel)
        toastContainer.addSubview(closeButton)
        view.addSubview(toastContainer)

        // Set up constraints for the toast container
        NSLayoutConstraint.activate([
            toastContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toastContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            toastContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            toastContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),

            // Constraints for the toast label
            toastLabel.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 10),
            toastLabel.centerYAnchor.constraint(equalTo: toastContainer.centerYAnchor),

            // Constraints for the close button
            closeButton.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor, constant: -10),
            closeButton.centerYAnchor.constraint(equalTo: toastContainer.centerYAnchor),
            closeButton.leadingAnchor.constraint(equalTo: toastLabel.trailingAnchor, constant: 10)
        ])

        // Animate the toast appearance
        toastContainer.alpha = 0.0
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            toastContainer.alpha = 1.0
        })

        // Set the current toast reference to the newly created toast
        currentToast = toastContainer
    }

    // Function to manually dismiss the toast when the cross button is clicked
    @objc static func dismissToast(sender: UIButton) {
        if let toastContainer = sender.superview {
            dismissToast(toast: toastContainer)
        }
    }

    // Function to dismiss a given toast view
    static func dismissToast(toast: UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            toast.alpha = 0.0
        }, completion: { _ in
            toast.removeFromSuperview()
            // Clear the current toast reference after it is dismissed
            if currentToast == toast {
                currentToast = nil
            }
        })
    }
}

