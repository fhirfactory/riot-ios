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

class DialViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var b1: UIView!
    @IBOutlet weak var b2: UIView!
    @IBOutlet weak var b3: UIView!
    @IBOutlet weak var b4: UIView!
    @IBOutlet weak var b5: UIView!
    @IBOutlet weak var b6: UIView!
    @IBOutlet weak var b7: UIView!
    @IBOutlet weak var b8: UIView!
    @IBOutlet weak var b9: UIView!
    @IBOutlet weak var b0: UIView!
    @IBOutlet weak var engage: UIView!
    @IBOutlet weak var textField: UITextField!
    
    static func nib() -> UINib! {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    func numberDialed(numberID: String) {
        if let val = Int(numberID) {
            //play dial tone
            AudioServicesPlaySystemSound(SystemSoundID(1200+val))
            if let t = textField.text {
                textField.text = t + numberID
            } else {
                textField.text = numberID
            }
        }
        print(numberID)
        
    }
    
    func makeButtonCallback(forNumber: String) -> () -> Void {
        return {
            self.numberDialed(numberID: forNumber)
        }
    }
    
    func setupButton(forView: UIView, withNumber: String) {
        let b = DialerButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        forView.addSubview(b)
        forView.addConstraints([b.topAnchor.constraint(equalTo: forView.topAnchor), b.bottomAnchor.constraint(equalTo: forView.bottomAnchor), b.leadingAnchor.constraint(equalTo: forView.leadingAnchor), b.trailingAnchor.constraint(equalTo: forView.trailingAnchor)])
        
        b.load(withNumber: withNumber, andAlphabet: AlternateHomeTools.getNSLocalized("dialer_"+withNumber, in: "Vector"), andCallback: makeButtonCallback(forNumber: withNumber))
        b.layer.masksToBounds = true
        b.layer.cornerRadius = forView.frame.height / 2
    }
    
    func setupEngageButton(forView: UIView) {
        let b = DialerButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        forView.addSubview(b)
        forView.addConstraints([b.topAnchor.constraint(equalTo: forView.topAnchor), b.bottomAnchor.constraint(equalTo: forView.bottomAnchor), b.leadingAnchor.constraint(equalTo: forView.leadingAnchor), b.trailingAnchor.constraint(equalTo: forView.trailingAnchor)])
        
        b.load(withIcon: "voice_call_hangon_icon", andColor: .systemGreen) {
            
        }
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
        setupEngageButton(forView: engage)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        false
    }
    
}
