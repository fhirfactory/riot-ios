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

class DialViewController: UIViewController {
    @IBOutlet var b1: UIView!
    @IBOutlet var b2: UIView!
    @IBOutlet var b3: UIView!
    @IBOutlet var b4: UIView!
    @IBOutlet var b5: UIView!
    @IBOutlet var b6: UIView!
    @IBOutlet var b7: UIView!
    @IBOutlet var b8: UIView!
    @IBOutlet var b9: UIView!
    @IBOutlet var b0: UIView!
    static func nib() -> UINib! {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    func setupButton(forView: UIView, withNumber: String) {
        let b = DialerButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        forView.addSubview(b)
        forView.addConstraints([b.topAnchor.constraint(equalTo: forView.topAnchor), b.bottomAnchor.constraint(equalTo: forView.bottomAnchor), b.leadingAnchor.constraint(equalTo: forView.leadingAnchor), b.trailingAnchor.constraint(equalTo: forView.trailingAnchor)])
        
        b.load(withNumber: withNumber, andAlphabet: "MNO")
        b.layer.masksToBounds = true
        b.layer.cornerRadius = forView.frame.height / 2
    }
    
    override func viewDidLoad() {
        let b = DialerButton()
        
        ThemeService.shared().theme.recursiveApply(on: view)
        setupButton(forView: b1, withNumber: "1")
        setupButton(forView: b2, withNumber: "2")
        setupButton(forView: b3, withNumber: "3")
        setupButton(forView: b4, withNumber: "4")
        setupButton(forView: b5, withNumber: "5")
        setupButton(forView: b6, withNumber: "6")
        setupButton(forView: b7, withNumber: "7")
        setupButton(forView: b8, withNumber: "8")
        setupButton(forView: b9, withNumber: "9")
        setupButton(forView: b0, withNumber: "0")
        
    }
    
}
