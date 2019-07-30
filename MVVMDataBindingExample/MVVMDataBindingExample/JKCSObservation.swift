//
//  JKCSObservation.swift
//  TemplateApp
//
//  Created by Zhengqian Kuang on 2019-07-24.
//  Copyright © 2019 JandJ. All rights reserved.
//

import Foundation

// == Observable ==

protocol JKCSObservableProtocol {
    associatedtype T
    
    var value: T {get set}
    var writer: AnyObject? {get set}
    var observers: Array<JKCSObserver<T>> {get set}
}

extension JKCSObservableProtocol {
    mutating func addObserver(observer: JKCSObserver<T>) {
        for existed in observers {
            if existed === observer {
                return
            }
        }
        observers.append(observer)
    }
    
    mutating func removeObserver(observer: JKCSObserver<T>) {
        observers.removeAll { $0 === observer }
    }
    
    mutating func removeAllObservers() {
        observers.removeAll()
    }
    
    func valueDidChange(oldValue: T, newValue: T) {
        observers.forEach { (observer) in
            observer.valueDidChange(oldValue: oldValue, newValue: newValue)
        }
    }
}

class JKCSObservable<T>: JKCSObservableProtocol {
    var value: T {
        didSet {
            if autoSave {
                UserDefaults.standard.set(value, forKey: autoSaveKey)
            }
            valueDidChange(oldValue: oldValue, newValue: value)
        }
    }
    var writer: AnyObject? = nil
    var observers: Array<JKCSObserver<T>> = []
    
    // auto save, optional
    // BONUS FEATURE: autoSave - "autoSave"/"autoSaveKey" is a pair of members offering a "bonus" feature, autoSave, which is usefule but has nothing to do with observation itself. When initialized with a non-empty key string, the new value changed will be automatically saved into UserDefaults.standard to the key string. And each time the app restarts, the saved value will be automatically retrieved from UserDefaults.standard. This can be very helpful for those values serve as user preferrences. To see the effect, run the example and adjust the RGB color to some non-zero value and then kill the app. When you restart the app, the color you set before will be resumed, which is the magic of "autoSave".
    private var autoSave = false
    private let autoSaveKey: String
    
    init(value: T, autoSaveKey: String = "", resume: Bool = true) {
        self.value = value
        self.autoSaveKey = autoSaveKey
        if autoSaveKey != "" {
            autoSave = true
            if resume {
                if let resumeValue = UserDefaults.standard.value(forKey: autoSaveKey) {
                    self.value = resumeValue as! T
                }
            }
        }
    }
}

// == Observer ==

protocol JKCSObserverProtocol {
    associatedtype T
    
    func valueDidChange(oldValue: T, newValue: T)
}

class JKCSObserver<T>: JKCSObserverProtocol {
    private var observable: JKCSObservable<T>
    private let valueDidChange: (_ oldValue: T, _ newValue: T) -> ()
    
    init(observable: JKCSObservable<T>,
         valueDidChange: @escaping (_ oldValue: T, _ newValue: T) -> ()) {
        self.observable = observable
        self.valueDidChange = valueDidChange
    }
    
    deinit {
        observable.removeObserver(observer: self)
    }
    
    func start() -> JKCSObserver {
        observable.addObserver(observer: self)
        return self
    }
    
    func stop() {
        observable.removeObserver(observer: self)
    }
    
    func valueDidChange(oldValue: T, newValue: T) {
        valueDidChange(oldValue, newValue)
    }
}
