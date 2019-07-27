//
//  ColorBlend.swift
//  MVVMDataBindingExample
//
//  Created by Zhengqian Kuang on 2019-07-26.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import Foundation

struct JKCSRGBColor {
    var red = JKCSObservable<Int>(value: 0)
    var green = JKCSObservable<Int>(value: 0)
    var blue = JKCSObservable<Int>(value: 0)
}
