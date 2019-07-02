//
//  ColorMixture.swift
//  MVVMDataBindingExample
//
//  Created by John Kuang on 2019-07-02.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import Foundation

class ColorMixture : NSObject {
    
    @objc dynamic var red: Int = 0
    @objc dynamic var green: Int = 0
    @objc dynamic var blue: Int = 0
    var writer: AnyObject? = nil
    
    static let shared = ColorMixture()
    
    override private init() {
        //
    }
    
}
