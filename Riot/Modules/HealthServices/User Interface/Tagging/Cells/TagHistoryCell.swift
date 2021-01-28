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

class TagHistoryCell: UITableViewCell {
    func render(withTagData tagData: TagData) {
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
        let stackView = Stackview()
        var subviews: [UIView] = []
        if tagData.FileContainsPatient {
            guard let patientTagCell = Bundle(for: PatientViewCell.self).loadNibNamed("PatientViewCell", owner: PatientViewCell(), options: nil)?.first as? PatientViewCell else { return }
            guard let patient = tagData.Patients.first else { return }
            patientTagCell.RenderWith(Object: patient)
            let patientTagView = patientTagCell.contentView
            patientTagView.translatesAutoresizingMaskIntoConstraints = false
            subviews.append(patientTagView)
        }
        
        guard let descriptionCell = Bundle(for: ImageDescriptionCell.self).loadNibNamed("ImageDescriptionCell", owner: ImageDescriptionCell(), options: nil)?.first as? ImageDescriptionCell else { return }
        let viewModel = PatientTaggingViewController.produceViewModel(fromTagData: [tagData])
        descriptionCell.render(viewModel: viewModel)
        descriptionCell.setAsReadOnly()
        descriptionCell.sizeToFit()
        let descriptionView = descriptionCell.contentView
        subviews.append(descriptionView)
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.initWithViews(subviews)
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        contentView.layoutIfNeeded()
        ThemeService.shared().theme.recursiveApply(on: contentView)
    }
}
