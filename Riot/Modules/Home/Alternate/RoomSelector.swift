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

class RoomSelector: TabbedHomeViewController {
    static override func nib() -> UINib! {
        UINib(nibName: "TabbedHomeViewController", bundle: Bundle(for: self))
    }
    public var callback: ((MXRoom) -> Void)!
    @objc public var titleText: String?
    @objc public func SetCallback(_ callback : @escaping ((MXRoom) -> Void)) {
        self.callback = {(room) in
            //dismiss ourselves (to dismiss the popover view)
            self.dismiss(animated: true, completion: nil)
            callback(room)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.enableCreateRoomButton = false
        super.SelectedRoomHandler = callback
        if let labelString = titleText {
            var subviews: [UIView] = []
            let labelContainer = UIView()
            labelContainer.translatesAutoresizingMaskIntoConstraints = false
            
            let label = UILabel()
            label.text = labelString
            label.translatesAutoresizingMaskIntoConstraints = false
            labelContainer.addSubview(label)
            labelContainer.addConstraints([
                label.centerXAnchor.constraint(equalTo: labelContainer.centerXAnchor),
                label.topAnchor.constraint(equalTo: labelContainer.topAnchor, constant: 10),
                labelContainer.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 10)
            ])
            subviews.append(labelContainer)
            sections.view.translatesAutoresizingMaskIntoConstraints = false
            subviews.append(sections.view)
            let stacked = Stackview()
            stacked.initWithViews(subviews)
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
            stacked.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(stacked)
            view.addConstraints([
                view.leadingAnchor.constraint(equalTo: stacked.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: stacked.trailingAnchor),
                view.topAnchor.constraint(equalTo: stacked.topAnchor),
                view.bottomAnchor.constraint(equalTo: stacked.bottomAnchor)
            ])
            
            
            view.layoutIfNeeded()
        }
    }
}
