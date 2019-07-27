//
//  JKCSObservation.swift
//  TemplateApp
//
//  Created by Zhengqian Kuang on 2019-07-24.
//  Copyright © 2019 JandJ. All rights reserved.
//

import Foundation

// == Observable ==

protocol JKCSProtocolObservable {
    associatedtype T
    
    var value: T {get set}
    var writer: AnyObject? {get set}
    var observers: Array<JKCSObserver<T>> {get set}
}

extension JKCSProtocolObservable {
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

class JKCSObservable<T>: JKCSProtocolObservable {
    var value: T {
        didSet {
            valueDidChange(oldValue: oldValue, newValue: value)
        }
    }
    var writer: AnyObject? = nil
    var observers: Array<JKCSObserver<T>> = []
    
    init(value: T) {
        self.value = value
    }
}

// == Observer ==

protocol JKCSProtocolObserver {
    associatedtype T
    
    func valueDidChange(oldValue: T, newValue: T)
}

class JKCSObserver<T>: JKCSProtocolObserver {
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
