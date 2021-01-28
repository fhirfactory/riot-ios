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
    private var callbackPrivate: ((MXRoom) -> Void)!
    //little cheat for a, 3-state boolean
    private var viewHasLoaded: Bool? = false
    @objc public var titleText: String?
    @objc public func SetCallback(_ callback : @escaping ((MXRoom) -> Void)) {
        callbackPrivate = callback
        if self.callback == nil {
            self.callback = {(room) in
                //dismiss ourselves (to dismiss the popover view)
                self.dismiss(animated: true, completion: nil)
                self.callbackPrivate(room)
            }
        }
        if viewHasLoaded == true {
            completeInitialization()
            //don't reinitialize if we change call setCallback again.
            //we wouldn't even need to anyway, as the callback is a referenced field on this object.
            viewHasLoaded = nil
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.enableCreateRoomButton = false
        //assume that we don't want to draw the view if there is no attached completion handler
        //normally this wouldn't be an issue -- we would allocate the view, and then we would set the completion handler, then we would present the view (presenting would lead to viewWillAppear).
        //since this is called by the AppDelegate though (to forward messages) things work a little differently -- the initialization chain from the AppDelegate calls viewWillAppear in the [v new] call. This is obviously before we can set the callback field.
        //hence, as we need to have this callback before completing the initialization of the view (as the components that will make up the view are not looking for some "callbackChanged" event), we effectively delay the initialization if we don't have the callback
        if callback != nil {
            completeInitialization()
        }
        viewHasLoaded = true
    }
    
    func completeInitialization() {
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
