//
//  ColorMixture.swift
//  MVVMDataBindingExample
//
//  Created by John Kuang on 2019-07-02.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import Foundation

//
// ColorMixture serves as the view model
// UI views (view controllers) observe changes in the view model to update themselves
// Changes in view model itself can also trigger the updates for the back-end model
//

class ColorMixture : NSObject {
    
    @objc dynamic var red: Int = 0 {
        didSet {
            // update the back-end model
        }
    }
    @objc dynamic var green: Int = 0 {
        didSet {
            // update the back-end model
        }
    }
    @objc dynamic var blue: Int = 0 {
        didSet {
            // update the back-end model
        }
    }
    
    // For recording who changed the value
    // In some cases, a UI element can both be the changer and the observer of a same observable. It may cause an infinite loop like
    //  (1) The user operates the UI and changes the value of a UI element, say controlA
    //  (2) controlA's listener is triggered by the change, and then writes the new value to the observable, say observableO
    //  (3) The onChange block of the observer is triggered by observerO's value change, and then updates all the related UI elements, including controlA
    //  (4) controlA's listener is triggered again by step(3) and an infinite loop between step(2) and step(3) started
    //  (...)
    //  (n) Finally the app crashed
    // To avoid this, in this scenario, in step(2), mark the "writer" as self (controlA) before writing the new value to the observable, and in step(3), update all the UI elements OTHER THAN the writer itself.
    var writer: AnyObject? = nil
    
    static let shared = ColorMixture()
    
    override private init() {
        //
    }
    
}
