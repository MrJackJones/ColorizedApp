import UIKit

protocol SettingsViewControllerDelegate {
    func setBackgroundColor(color: UIColor)
}

class MainViewController: UIViewController {    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingsViewController else {return}
        settingsVC.currentColor = view.backgroundColor
        settingsVC.delegate = self
    }
}

// MARK: - SettingsViewControllerDelegate
extension MainViewController: SettingsViewControllerDelegate {
    func setBackgroundColor(color: UIColor) {
        view.backgroundColor = color
    }
}
