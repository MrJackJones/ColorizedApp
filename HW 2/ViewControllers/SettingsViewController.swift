import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet var redTF: UITextField!
    @IBOutlet var greenTF: UITextField!
    @IBOutlet var blueTF: UITextField!
    
    var currentColor: UIColor!
    var delegate: SettingsViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 15
        
        redTF.delegate = self
        greenTF.delegate = self
        blueTF.delegate = self
        
        redSlider.minimumTrackTintColor = .red
        greenSlider.minimumTrackTintColor = .green
        
        addDoneButtonOnNumpad(textField: redTF)
        addDoneButtonOnNumpad(textField: greenTF)
        addDoneButtonOnNumpad(textField: blueTF)
        
        hideKeyboardWhenTappedAround()
        
        setSlider()
        setColor()
        setValue(for: redLabel, greenLabel, blueLabel)
    }
    
    @IBAction func rgbSlider(_ sender: UISlider) {
        setColor()
        switch sender {
            case redSlider:
                redLabel.text = string(from: redSlider)
                redTF.text = string(from: redSlider)
            case greenSlider:
                greenLabel.text = string(from: greenSlider)
                greenTF.text = string(from: greenSlider)
            default:
                blueLabel.text = string(from: blueSlider)
                blueTF.text = string(from: blueSlider)
        }
    }
    
    @IBAction func doneButton() {
        delegate.setBackgroundColor(color: currentColor)
        dismiss(animated: true)
    }
    
    func setSlider() {
        redSlider.value = Float(CIColor(color: currentColor).red)
        greenSlider.value = Float(CIColor(color: currentColor).green)
        blueSlider.value = Float(CIColor(color: currentColor).blue)
    }
    
    private func setColor() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
        currentColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
    
    private func setValue(for labels: UILabel...) {
        labels.forEach { label in
            switch label {
                case redLabel:
                    redLabel.text = string(from: redSlider)
                    redTF.text = string(from: redSlider)
                case greenLabel:
                    greenLabel.text = string(from: greenSlider)
                    greenTF.text = string(from: greenSlider)
                default:
                    blueLabel.text = string(from: blueSlider)
                    blueTF.text = string(from: blueSlider)
            }
        }
    }
    
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
}

// MARK: - Other Settings for VC
extension SettingsViewController {
    func showAlert() {
        let alert = UIAlertController(title: "Invalid value", message: "Please enter value from 0 to 1.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Keyboard
extension SettingsViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addDoneButtonOnNumpad(textField: UITextField) {
        let keypadToolbar: UIToolbar = UIToolbar()
        keypadToolbar.items=[
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: textField, action: #selector(UITextField.resignFirstResponder))
        ]
        textField.keyboardType = .decimalPad
        keypadToolbar.sizeToFit()
        textField.inputAccessoryView = keypadToolbar
    }
}

// MARK: - UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let newValue = textField.text else {return}
        guard let numberValue = Float(newValue) else {return}
        if numberValue > 1 {
            showAlert()
            return
        }
        
        if textField == redTF {
            redLabel.text = newValue
            redSlider.value = numberValue
        } else if textField == greenTF {
            greenLabel.text = newValue
            greenSlider.value = numberValue
            
        } else {
            blueLabel.text = newValue
            blueSlider.value = numberValue
        }
        setColor()
    }
}
