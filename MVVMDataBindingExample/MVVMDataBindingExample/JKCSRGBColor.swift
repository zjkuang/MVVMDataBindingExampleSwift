//
//  ColorBlend.swift
//  MVVMDataBindingExample
//
//  Created by Zhengqian Kuang on 2019-07-26.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import Foundation

struct JKCSRGBColor {
    var red = JKCSObservable<Int>(value: 0, autoSaveKey: "4AD47D3C")
    var green = JKCSObservable<Int>(value: 0, autoSaveKey: "F5DAAFD8")
    var blue = JKCSObservable<Int>(value: 0, autoSaveKey: "56DC0E01")
}
