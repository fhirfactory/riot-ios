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
class LegacyTagViewContainer: UITableViewCell {
    @IBOutlet weak var Container: UIView!
    @objc func render(tags: [TagData]) {
        Container.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        let tagCell = PatientTagHelpers.getPatientViewCell(ForTagData: tags, forTimeline: true)
        if let returnView = tagCell?.returnView {
            returnView.translatesAutoresizingMaskIntoConstraints = false
            Container.addSubview(returnView)
            Container.addConstraints([
                Container.leadingAnchor.constraint(equalTo: returnView.leadingAnchor),
                Container.trailingAnchor.constraint(equalTo: returnView.trailingAnchor),
                Container.topAnchor.constraint(equalTo: returnView.topAnchor),
                Container.bottomAnchor.constraint(equalTo: returnView.bottomAnchor)
            ])
        }
    }
    @objc static func getHeight(tags: [TagData], withWidth: CGFloat) -> CGFloat {
        //width - (51 + 10) -- the two constraints
        //this should probably be updated to dynamically figure out the constraints
        let view = UIView(frame: CGRect(x: 0, y: 0, width: withWidth - 61, height: 0))
        view.translatesAutoresizingMaskIntoConstraints = false
        let tagCell = PatientTagHelpers.getPatientViewCell(ForTagData: tags, forTimeline: true)
        if let returnView = tagCell?.returnView {
            returnView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(returnView)
            view.addConstraints([
                view.leadingAnchor.constraint(equalTo: returnView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: returnView.trailingAnchor),
                view.topAnchor.constraint(equalTo: returnView.topAnchor),
                view.bottomAnchor.constraint(equalTo: returnView.bottomAnchor)
            ])
            view.layoutIfNeeded()
            view.sizeToFit()
            let height = view.frame.height
            let descriptionHeight = (tagCell?.patientDetailsView?.frame.height ?? 0) + (tagCell?.descriptionView?.frame.height ?? 0) + (tagCell?.tagChangesWarningView?.frame.height ?? 0)
            return descriptionHeight
        }
        return 0
    }
}
