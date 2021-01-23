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

class RecentCallItem: UITableViewCell, UIScrollViewDelegate {
    @IBOutlet weak var CallIcon: UIImageView!
    @IBOutlet weak var CallerLabel: UILabel!
    @IBOutlet weak var DateTimeLabel: UILabel!
    @IBOutlet weak var CallDescriptionLabel: UILabel!
    @IBOutlet weak var CallLengthLabel: UILabel!
    @IBOutlet weak var CallInfoButton: UIButton!
    @IBOutlet weak var CallOverviewSection: UIView!
    @IBOutlet weak var CallDetails: UIView!
    @IBOutlet weak var DetailsScrollView: UIScrollView!
    @IBOutlet weak var DetailsTopLabel: UILabel!
    @IBOutlet weak var DetailsBottomLabel: UILabel!
    @IBOutlet weak var DetailsButtonConstraint: NSLayoutConstraint!
    
    @IBAction private func DisplayCallInfo(_ sender: Any) {
        if DetailsScrollView.bounds.minX == 0 {
            DetailsScrollView.scrollRectToVisible(CGRect(x: DetailsScrollView.contentSize.width - 1, y: 1, width: 1, height: 1), animated: true)
        } else {
            DetailsScrollView.scrollRectToVisible(CGRect(x: 0, y: 1, width: 1, height: 1), animated: true)
        }
    }
    
    struct TimeSpan {
        let hours: Int
        let minutes: Int
        let seconds: Int
        let milliseconds: Double
        func getDescriptiveString() -> String {
            if hours > 0 {
                return String(format: "%dh %dm %ds", hours, minutes, seconds)
            }
            if minutes > 0 {
                return String(format: "%dm %ds", minutes, seconds)
            }
            return String(format: "%ds", seconds)
        }
        init(fromDuration duration: TimeInterval) {
            hours = Int(duration / (60 * 60))
            minutes = Int(duration / 60) - hours * 60
            seconds = Int(duration) - minutes * 60
            milliseconds = 1000 * (duration - Double(seconds))
        }
    }
    
    @available(iOS 13.0, *)
    func getIcon(forCall call: Call) -> UIImage? {
        switch call.direction {
        case .incoming:
            return UIImage(systemName: "phone.arrow.down.left")?.vc_tintedImage(usingColor: ThemeService.shared().theme.tintColor)
        case .outgoing:
            return UIImage(systemName: "phone.arrow.up.right")?.vc_tintedImage(usingColor: ThemeService.shared().theme.tintColor)
        case .missed:
            return UIImage(systemName: "phone.down.circle")?.vc_tintedImage(usingColor: .systemRed) //need a proper icon for this
        }
    }
    
    func render(phoneCall call: Call) {
        ThemeService.shared().theme.recursiveApply(on: CallOverviewSection)
        ThemeService.shared().theme.recursiveApply(on: CallDetails)
        if #available(iOS 13.0, *) {
            CallIcon.image = getIcon(forCall: call)
        } else {
            // Fallback on earlier versions
        }
        CallDescriptionLabel.text = call.description
        CallerLabel.text = call.with
        let length = TimeSpan(fromDuration: call.length)
        CallLengthLabel.text = length.getDescriptiveString()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM h:mm a"
        DateTimeLabel.text = dateFormatter.string(from: call.time)
        DetailsScrollView.backgroundColor = ThemeService.shared().theme.backgroundColor
        if let extraInfo = call.extraInfo {
            CallInfoButton.isHidden = false
            DetailsBottomLabel.text = extraInfo.data
            DetailsTopLabel.text = extraInfo.infoString
            DetailsScrollView.isScrollEnabled = true
            DetailsButtonConstraint.isActive = false
        } else {
            CallInfoButton.isHidden = true
            DetailsScrollView.isScrollEnabled = false
            DetailsButtonConstraint.isActive = true
            DetailsButtonConstraint.constant = 0
        }
    }
}
