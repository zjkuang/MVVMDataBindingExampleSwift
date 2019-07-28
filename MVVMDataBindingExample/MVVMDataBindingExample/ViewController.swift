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
    
    var rgbColor: JKCSRGBColor?
    
    var redValueObserver: JKCSObserver<Int>?
    var greenValueObserver: JKCSObserver<Int>?
    var blueValueObserver: JKCSObserver<Int>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setKeypadPreferences()
        
        rgbColor = JKCSRGBColor()
        setObservers()
        updateView()
    }
    
    private func setObservers() {
        redValueObserver = JKCSObserver<Int>(observable: rgbColor!.red, valueDidChange: { [weak self] (oldValue, newValue) in
            self?.updateView()
        }).start()
        
        greenValueObserver = JKCSObserver<Int>(observable: rgbColor!.green, valueDidChange: { [weak self] (oldValue, newValue) in
            self?.updateView()
        }).start()
        
        blueValueObserver = JKCSObserver<Int>(observable: rgbColor!.blue, valueDidChange: { [weak self] (oldValue, newValue) in
            self?.updateView()
        }).start()
    }
    
    private func updateView() {
        if (!(self.redSlider === self.rgbColor?.red.writer)) {
            self.redSlider.value = Float(self.rgbColor?.red.value ?? 0) / 255.0
        }
        if (!(self.redTextField === self.rgbColor?.red.writer)) {
            self.redTextField.text = "\(self.rgbColor?.red.value ?? 0)"
        }
        if (!(self.greenSlider === self.rgbColor?.green.writer)) {
            self.greenSlider.value = Float(self.rgbColor?.green.value ?? 0) / 255.0
        }
        if (!(self.greenTextField === self.rgbColor?.green.writer)) {
            self.greenTextField.text = "\(self.rgbColor?.green.value ?? 0)"
        }
        if (!(self.blueSlider === self.rgbColor?.blue.writer)) {
            self.blueSlider.value = Float(self.rgbColor?.blue.value ?? 0) / 255.0
        }
        if (!(self.blueTextField === self.rgbColor?.blue.writer)) {
            self.blueTextField.text = "\(self.rgbColor?.blue.value ?? 0)"
        }
        
        let colorCode = String(format: "%02X%02X%02X", rgbColor!.red.value, rgbColor!.green.value, rgbColor!.blue.value)
        let color = UIColor(red: CGFloat(rgbColor!.red.value) / 255.0, green: CGFloat(rgbColor!.green.value) / 255.0, blue: CGFloat(rgbColor!.blue.value) / 255.0, alpha: 1.0)
        let complementaryColor = UIColor(red: CGFloat(255 - rgbColor!.red.value) / 255.0, green: CGFloat(255 - rgbColor!.green.value) / 255.0, blue: CGFloat(255 - rgbColor!.blue.value) / 255.0, alpha: 1.0)
        colorCodeLable.text = colorCode
        colorCodeLable.textColor = color
        colorCodeLable.backgroundColor = complementaryColor
        colorView.backgroundColor = color
    }
    
    @IBAction func redSliderValueDidChange(_ sender: Any) {
        rgbColor?.red.writer = redSlider
        rgbColor?.red.value = Int(redSlider.value * 255.0)
    }
    
    @IBAction func greenSliderValueDidChange(_ sender: Any) {
        rgbColor?.green.writer = greenSlider
        rgbColor?.green.value = Int(greenSlider.value * 255.0)
    }
    
    @IBAction func blueSliderValueDidChange(_ sender: Any) {
        rgbColor?.blue.writer = blueSlider
        rgbColor?.blue.value = Int(blueSlider.value * 255.0)
    }
}

extension ViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        firstResponder = textField
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let value = (Int(textField.text ?? "") ?? 0) % 256
        textField.text = "\(value)"
        if textField == redTextField {
            rgbColor?.red.writer = textField
            rgbColor?.red.value = value
        }
        if textField == greenTextField {
            rgbColor?.green.writer = textField
            rgbColor?.green.value = value
        }
        if textField == blueTextField {
            rgbColor?.blue.writer = textField
            rgbColor?.blue.value = value
        }
    }
}

extension ViewController {
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

