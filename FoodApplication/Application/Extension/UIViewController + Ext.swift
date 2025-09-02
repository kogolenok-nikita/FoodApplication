import UIKit

extension UIViewController {
    func presentAlert(title: String = "", message: String, retry: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let retry {
            alert.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in retry() })
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.present(alert, animated: true)
        }
    }
}
