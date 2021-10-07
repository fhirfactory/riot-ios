//
//  SearchDebouncer.swift
//  Riot
//
//  Created by Joseph Fergusson on 8/7/21.
//  Copyright © 2021 matrix.org. All rights reserved.
//

import Foundation

class Debouncer<T> {
    
    var callback: (T) -> Void
    var timeDelay: Double = 0.2
    init(callback: @escaping (T) -> Void, timeDelay: Double = 1) {
        self.callback = callback
        self.timeDelay = timeDelay
    }
    
    var request: UInt32 = 0
    func TrySetValue(value: T){
        request = arc4random()
        let code = request
        DispatchQueue.main.asyncAfter(deadline: .now() + timeDelay) {
            if (code == self.request) {
                self.callback(value)
            }
        }
    }
    
}
