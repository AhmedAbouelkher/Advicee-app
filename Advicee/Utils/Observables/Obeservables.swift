//
//  Obeservables.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 08/05/2021.
//

import Foundation

class MultiObservable<T> {
    var value: T? {
        didSet {
            self.listeners.forEach { $0(value) }
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
    
    private var listeners: [((T?) -> Void)] = []
    
    public func bind(_ listener: @escaping (T?) -> Void) {
        listener(value)
        self.listeners.append(listener)
    }
}

class Observable<T> {
    var value: T? {
        didSet {
            self.listener?(value)
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
    
    private var listener: ((T?) -> Void)?
    
    public func bind(_ listener: @escaping (T?) -> Void) {
        listener(value)
        self.listener = listener
    }
}
