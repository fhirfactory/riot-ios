// 
// Copyright 2020 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

class ViewDebuggingTools {
    static func traceGestureRecognizersForScreen(fromView view: UIView) {
        var theView = view
        while true {
            guard let v = theView.superview else { break }
            theView = v
        }
        traceGestureRecognizersForSubviews(ofView: theView)
    }
    
    static func traceGestureRecognizersForSubviews(ofView view: UIView) {
        if let recognizers = view.gestureRecognizers {
            for gestureRecognizer in recognizers {
                /*
                if let targets = gestureRecognizer.value(forKey: "_targets") {
                    if let v = targets as? NSArray {
                        for t in v {
                            if let target = t as? NSObject {
                                var ivarCount: UInt32 = 0
                                let ivarlist = class_copyIvarList(type(of: target), &ivarCount)
                                var propCount: UInt32 = 0
                                var proplist = class_copyPropertyList(type(of: target), &propCount)
                                for _ in 0..<propCount {
                                    guard let prop = proplist?.pointee else { break }
                                    let strptr = property_getName(prop)
                                    let name = NSString(format: "%s", strptr)
                                    proplist = proplist?.advanced(by: 1)
                                }
                                guard let object = target.value(forKey: "target") as? NSObject else { continue }
                                guard let selector = target.value(forKey: "action") as? Selector else { continue }
                                print(object)
                                print(selector)
                            }
                        }
                    }
                }
 */
                gestureRecognizer.removeTarget(self, action: #selector(gestureRecognizerDebugHook(_:)))
                gestureRecognizer.addTarget(self, action: #selector(gestureRecognizerDebugHook(_:)))
            }
        }
        for subview in view.subviews {
            traceGestureRecognizersForSubviews(ofView: subview)
        }
    }
    
    @objc static func gestureRecognizerDebugHook(_ recognizer: UIGestureRecognizer) {
        print("--------------")
        print(recognizer.description)
        print("Received event")
        print("--------------")
        guard let view = recognizer.view else { return }
        let color = view.backgroundColor
        let newColor = UIColor.orange
        UIView.animate(withDuration: 1.0) {
            view.backgroundColor = newColor
            view.subviews.forEach { (v) in
                v.backgroundColor = newColor
            }
        } completion: { (complete) in
            UIView.animate(withDuration: 1.0) {
                view.backgroundColor = color
                view.subviews.forEach { (v) in
                    v.backgroundColor = color
                }
            }
        }

    }
    
}
