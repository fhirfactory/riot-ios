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

class MessageContentView: UITableViewCell {
    private var queuedRender: MXKRoomBubbleCellData? //obviously not an actual queue
    private var width: CGFloat = 0
    private var viewHasLoaded: Bool = false
    weak var delegate: RoomMessageContentCell!
    class func nib() -> UINib! {
        preconditionFailure("nib method must be overridden")
    }
    class func reuseIdentifier() -> String {
        preconditionFailure("reuseIdentifier should be overridden")
    }
    
    final func render(celldata: MXKRoomBubbleCellData, width: CGFloat = 0) {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLongPress)))
        self.width = width
        if viewHasLoaded {
            renderData(celldata, width)
        } else {
            queuedRender = celldata
        }
    }
    
    @IBAction private func onLongPress() {
        
    }
    
    internal func renderData(_ celldata: MXKRoomBubbleCellData, _ width: CGFloat = 0) {
        preconditionFailure("Override in inherriting class")
    }
    private var queuedTheme: Theme?
    final func applyStyle(_ theme: Theme) {
        if viewHasLoaded {
            applyTheStyle(theme)
        } else {
            queuedTheme = theme
        }
    }
    internal func applyTheStyle(_ theme: Theme) {
        preconditionFailure("Override in inherriting class")
    }
    
    func hasLoadedView() {
        if let dequeuedRender = queuedRender { //obviously not actually dequeueing
            renderData(dequeuedRender, width)
            queuedRender = nil
        }
        if let dequeuedTheme = queuedTheme {
            applyTheStyle(dequeuedTheme)
            queuedTheme = nil
        }
        viewHasLoaded = true
    }
    
    private func finalizeInitialization() {
        guard let nib = type(of: self).nib() else { return }
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
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
        hasLoadedView()
    }
}
