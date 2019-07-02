//
//  ViewController.swift
//  MVVMDataBindingExample
//
//  Created by John Kuang on 2019-06-26.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var blueTextField: UITextField!
    @IBOutlet weak var colorCodeLable: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    var firstResponder: AnyObject?
    
    var redValueObservation: NSKeyValueObservation?
    var greenValueObservation: NSKeyValueObservation?
    var blueValueObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setKeypadPreferences()
        
        setKVO()
        
        ColorMixture.shared.writer = self
        ColorMixture.shared.red = 0
        ColorMixture.shared.green = 0
        ColorMixture.shared.blue = 0
    }
    
    private func setKVO() {
        redValueObservation = ColorMixture.shared.observe(
            \ColorMixture.red,
            options: [.old, .new],
            changeHandler: { [weak self] object, change in
                if object != self?.redSlider {
                    self?.redSlider.value = Float(change.newValue ?? 0) / 255.0
                }
                if object != self?.redTextField {
                    self?.redTextField.text = "\(change.newValue ?? 0)"
                }
                self?.mixColor()
        })
        
        greenValueObservation = ColorMixture.shared.observe(
            \ColorMixture.green,
            options: [.old, .new],
            changeHandler: { [weak self] object, change in
                if object != self?.greenSlider {
                    self?.greenSlider.value = Float(change.newValue ?? 0) / 255.0
                }
                if object != self?.greenTextField {
                    self?.greenTextField.text = "\(change.newValue ?? 0)"
                }
                self?.mixColor()
        })
        
        blueValueObservation = ColorMixture.shared.observe(
            \ColorMixture.blue,
            options: [.old, .new],
            changeHandler: { [weak self] object, change in
                if object != self?.blueSlider {
                    self?.blueSlider.value = Float(change.newValue ?? 0) / 255.0
                }
                if object != self?.blueTextField {
                    self?.blueTextField.text = "\(change.newValue ?? 0)"
                }
                self?.mixColor()
        })
    }
    
    private func mixColor() {
        let colorCode = String(format: "%02X%02X%02X", ColorMixture.shared.red, ColorMixture.shared.green, ColorMixture.shared.blue)
        let color = UIColor(red: CGFloat(ColorMixture.shared.red) / 255.0, green: CGFloat(ColorMixture.shared.green) / 255.0, blue: CGFloat(ColorMixture.shared.blue) / 255.0, alpha: 1.0)
        let complementaryColor = UIColor(red: CGFloat(255 - ColorMixture.shared.red) / 255.0, green: CGFloat(255 - ColorMixture.shared.green) / 255.0, blue: CGFloat(255 - ColorMixture.shared.blue) / 255.0, alpha: 1.0)
        colorCodeLable.text = colorCode
        colorCodeLable.textColor = color
        colorCodeLable.backgroundColor = complementaryColor
        colorView.backgroundColor = color
    }
    
    @IBAction func redSliderValueDidChange(_ sender: Any) {
        ColorMixture.shared.writer = redSlider
        ColorMixture.shared.red = Int(redSlider.value * 255.0)
    }
    
    @IBAction func greenSliderValueDidChange(_ sender: Any) {
        ColorMixture.shared.writer = greenSlider
        ColorMixture.shared.green = Int(greenSlider.value * 255.0)
    }
    
    @IBAction func blueSliderValueDidChange(_ sender: Any) {
        ColorMixture.shared.writer = blueSlider
        ColorMixture.shared.blue = Int(blueSlider.value * 255.0)
    }
    
    private func setKeypadPreferences() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [UIBarButtonItem(title: "Apply", style: .done, target: self, action: #selector(keypadApplyButtonTapped))]
        redTextField.inputAccessoryView = toolbar
        greenTextField.inputAccessoryView = toolbar
        blueTextField.inputAccessoryView = toolbar
    }
    
    @IBAction private func keypadApplyButtonTapped() {
        if let textField = (firstResponder as? UITextField) {
            textField.resignFirstResponder()
            firstResponder = nil
        }
    }
    
}

extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        firstResponder = textField
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let value = (Int(textField.text ?? "") ?? 0) % 255
        textField.text = "\(value)"
        ColorMixture.shared.writer = textField
        if textField == redTextField {
            ColorMixture.shared.red = value
        }
        if textField == greenTextField {
            ColorMixture.shared.green = value
        }
        if textField == blueTextField {
            ColorMixture.shared.blue = value
        }
    }
    
}

