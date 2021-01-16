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
    @IBOutlet weak var backspaceContainer: UIView!
    
    var backspaceEffectView: UIView!
    
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
            if textField.text?.count == 1 {
                UIView.animate(withDuration: 0.1) {
                    self.backspaceContainer.alpha = 1.0
                }
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
        forView.addConstraints(
            [b.topAnchor.constraint(equalTo: forView.topAnchor),
             b.bottomAnchor.constraint(equalTo: forView.bottomAnchor),
             b.leadingAnchor.constraint(equalTo: forView.leadingAnchor),
             b.trailingAnchor.constraint(equalTo: forView.trailingAnchor)
            ])
        
        b.load(withIcon: "voice_call_hangon_icon", andColor: .systemGreen) {
            
        }
        b.layer.masksToBounds = true
        b.layer.cornerRadius = forView.frame.height / 2
    }
    
    override func viewDidLoad() {
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
        
        let backspaceRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(backspace))
        backspaceRecognizer.minimumPressDuration = 0
        backspaceRecognizer.cancelsTouchesInView = false
        backspaceContainer.addGestureRecognizer(backspaceRecognizer)
        
        backspaceContainer.alpha = 0
    }
    
    var count: Int = 0
    
    class BackspaceRequest: NSObject {
        weak var recognizer: UIGestureRecognizer!
        var count: Int = 0
        init(withRecognizer: UIGestureRecognizer, andCount: Int) {
            recognizer = withRecognizer
            count = andCount
        }
    }
    
    @objc func performBackspace(backspaceRequest: BackspaceRequest) {
        guard let recognizer = backspaceRequest.recognizer else { return }
        guard backspaceRequest.count == count else { return }
        if recognizer.state != .cancelled && recognizer.state != .possible {
            if let text = textField.text {
                if text.count > 0 {
                    if text.count == 1 {
                        self.backspaceContainer.alpha = 0
                    }
                    textField.text = String(text.prefix(text.count - 1))
                }
            }
            self.perform(#selector(self.performBackspace(backspaceRequest:)), with: backspaceRequest, afterDelay: 0.05)
        }
    }
    
    @objc func backspace(recognizer: UIGestureRecognizer) {
        if recognizer.state == .began {
            count += 1
            let touchLocation = recognizer.location(ofTouch: 0, in: backspaceContainer)
            UIView.animate(withDuration: 0.05) {
                self.backspaceContainer.alpha = 0.7
            } completion: { (_) in
                if touchLocation.x <= self.backspaceContainer.frame.width && touchLocation.x >= 0 && touchLocation.y <= self.backspaceContainer.frame.height && touchLocation.y >= 0 {
                    if let text = self.textField.text {
                        if text.count > 0 {
                            if text.count == 1 {
                                UIView.animate(withDuration: 0.1) {
                                    self.backspaceContainer.alpha = 0
                                }
                            }
                            self.textField.text = String(text.prefix(text.count - 1))
                        }
                    }
                }
                self.perform(#selector(self.performBackspace(backspaceRequest:)), with: BackspaceRequest(withRecognizer: recognizer, andCount: self.count), afterDelay: 1.0)
            }
        } else if recognizer.state == .ended && backspaceContainer.alpha != 0 {
            UIView.animate(withDuration: 0.05) {
                self.backspaceContainer.alpha = 1.0
            }
            count += 1
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        false
    }
    
}
