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
    
    // Quick guide - (2) declare an observer for each observable
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
        // Quick guide - (3) instantiate the observer by specifying (a) which observable it is observing, and (b) your processing closure on event valueDidChange
        redValueObserver = JKCSObserver<Int>(observable: rgbColor!.red, valueDidChange: { [weak self] (oldValue, newValue) in
            self?.updateView()
        }).start() // Quick guide - (4) and don't forget to kick off the observation by calling start()
        
        greenValueObserver = JKCSObserver<Int>(observable: rgbColor!.green, valueDidChange: { [weak self] (oldValue, newValue) in
            self?.updateView()
        }).start()
        
        blueValueObserver = JKCSObserver<Int>(observable: rgbColor!.blue, valueDidChange: { [weak self] (oldValue, newValue) in
            self?.updateView()
        }).start()
    }
    
    private func updateView() {
        //
        // IMPORTANT!!! - About the observer's 'writer' property
        // The UI elment who modified the observable's value shall not be re-updated, otherwise there will occur an infinite loop. Consider this senario,
        // (i) User slides the redSlider, (ii) redSliderValueDidChange() updates rgbColor.red.value, (iii) redValueObserver's observation closure gets triggered, (iv) redSlider's value is updated again, which falls into an infinite loop of (ii)-(iii)-(iv)-(ii)-(iii)-(iv)...
        // That's why the observable has a property "writer". Before redSlider update rgbColor.red.value, it shall set the writer to be itself, so that in (iii), redSlider can check the writer, if it was itself, its value will not be updated, by which means the infinite loop is avoided.
        //
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
        // Quick guide - (5) update the value property of the wrapped observable (and then all the observers observing this value will be triggered)
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

