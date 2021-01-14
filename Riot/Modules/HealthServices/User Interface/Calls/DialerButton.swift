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

class DialerButton: UIView {
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var buttonIcon: UIImageView!
    var effectView: UIView!
    var callback: (() -> Void)!
    
    static func nib() -> UINib! {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    func load(withNumber number: String, andAlphabet subtitle: String, andCallback callback: @escaping () -> Void) {
        guard let nib = type(of: self).nib() else { return }
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        self.callback = callback
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.backgroundColor = .none
        self.backgroundColor = .none
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
        ])
        subtitleLabel.textColor = ThemeService.shared().theme.textPrimaryColor
        numberLabel.textColor = ThemeService.shared().theme.textPrimaryColor
        numberLabel.text = number
        subtitleLabel.text = subtitle
        
        let touchDownRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(hover))
        touchDownRecognizer.cancelsTouchesInView = false
        touchDownRecognizer.minimumPressDuration = 0
        view.addGestureRecognizer(touchDownRecognizer)
        
        view.backgroundColor = ThemeService.shared().theme.tintBackgroundColor
        effectView = UIView()
        effectView.backgroundColor = .white
        effectView.alpha = 0
        effectView.translatesAutoresizingMaskIntoConstraints = false
        effectView.isUserInteractionEnabled = false
        
        self.addSubview(effectView)
        addConstraints(
            [
                effectView.topAnchor.constraint(equalTo: topAnchor),
                effectView.bottomAnchor.constraint(equalTo: bottomAnchor),
                effectView.leadingAnchor.constraint(equalTo: leadingAnchor),
                effectView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }
    
    func load(withIcon icon: String, andColor color: UIColor, andCallBack callback: @escaping () -> Void){
        guard let nib = type(of: self).nib() else { return }
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        self.callback = callback
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.backgroundColor = .none
        self.backgroundColor = .none
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
        ])
        subtitleLabel.text = ""
        numberLabel.text = ""
        buttonIcon.image = UIImage(named: icon)
        
        let touchDownRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(hover))
        touchDownRecognizer.cancelsTouchesInView = false
        touchDownRecognizer.minimumPressDuration = 0
        view.addGestureRecognizer(touchDownRecognizer)
        
        view.backgroundColor = color
        effectView = UIView()
        effectView.backgroundColor = .white
        effectView.alpha = 0
        effectView.translatesAutoresizingMaskIntoConstraints = false
        effectView.isUserInteractionEnabled = false
        
        self.addSubview(effectView)
        addConstraints(
            [
                effectView.topAnchor.constraint(equalTo: topAnchor),
                effectView.bottomAnchor.constraint(equalTo: bottomAnchor),
                effectView.leadingAnchor.constraint(equalTo: leadingAnchor),
                effectView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }
    
    @objc private func hover(recognizer: UIGestureRecognizer) {
        if recognizer.state == .began {
            UIView.animate(withDuration: 0.05) {
                self.effectView.alpha = 0.5
            }
        } else if recognizer.state == .ended {
            UIView.animate(withDuration: 0.2) {
                self.effectView.alpha = 0.0
            }
            let touchLocation = recognizer.location(ofTouch: 0, in: self)
            if touchLocation.x <= frame.width && touchLocation.x >= 0 && touchLocation.y <= frame.height && touchLocation.y >= 0 {
                callback()
            }
        }
    }
}
