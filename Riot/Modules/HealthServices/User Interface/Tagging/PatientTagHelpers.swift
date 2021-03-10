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

@objcMembers class PatientViewCellData: NSObject {
    var returnView: UIView?
    var includesPatientDetails: Bool = false
    var patientDetailsView: UIView?
    var descriptionView: UIView?
    var photographerDetailsView: UIView?
    var otherViews: UIView?
    var displayTagHistory: Bool = false
    var displayTagHistoryView: UIView?
    var tagChangesWarningView: UIView?
}

@objc class PatientTagHelpers: NSObject {
    @objc static func containsTagChanges(ForTagData tags: [TagData], andTag tag: TagData) -> Bool {
        tags.contains(where: { (t) -> Bool in
            t.Patients.count != tag.Patients.count || !t.Patients.allSatisfy({ (pm) -> Bool in
                tag.Patients.contains(pm)
            }) || !tag.Patients.allSatisfy({ (pm) -> Bool in
                t.Patients.contains(pm)
            })
        }) || !(tags.allSatisfy({ (t) -> Bool in
            t.Description == tag.Description
        }))
    }
    @objc static func historyContainsPatient(InTagData tags: [TagData]) -> Bool {
        !tags.allSatisfy { (x) -> Bool in
            x.Patients.count == 0
        }
    }
    @objc static func getPatientViewCell(ForTagData tags: [TagData]) -> PatientViewCellData? {
        return getPatientViewCell(ForTagData: tags, forTimeline: false)
    }
    
    @objc static func getPatientViewCell(ForTagData tags: [TagData], forTimeline: Bool = false) -> PatientViewCellData? {
        let returnData = PatientViewCellData()
        let returnView = Stackview()
        let childStackView = Stackview()
        childStackView.translatesAutoresizingMaskIntoConstraints = false
        
        var topLevelViews: [UIView] = []
        var subviews: [UIView] = []
        
        guard let tag = tags.last else { return nil }
        guard let descriptionCell = Bundle(for: ImageDescriptionViewCell.self).loadNibNamed("ImageDescriptionViewCell", owner: ImageDescriptionViewCell(), options: nil)?.first as? ImageDescriptionViewCell else { return nil}
        let viewModel = PatientTaggingViewController.produceViewModel(fromTagData: tags)
        descriptionCell.render(withString: viewModel.description ?? "")
        descriptionCell.sizeToFit()
        let descriptionView = descriptionCell.contentView
        if !forTimeline {
            descriptionView.backgroundColor = ThemeService.shared().theme.backgroundShadedColor
        }
    
        //subviews.append(descriptionView)
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        returnData.descriptionView = descriptionView
        
        guard let timeCell = Bundle(for: DateTakenViewCell.self).loadNibNamed("DateTakenViewCell", owner: DateTakenViewCell(), options: nil)?.first as? DateTakenViewCell else { return nil}
        timeCell.RenderWith(Object: tag.TakenDate)
        let timeView = timeCell.contentView
        
        timeView.translatesAutoresizingMaskIntoConstraints = false
        timeView.sizeToFit()
        
        if tag.FileContainsPatient {
            returnData.includesPatientDetails = true
            guard let patientTagCell = Bundle(for: PatientViewCell.self).loadNibNamed("PatientViewCell", owner: PatientViewCell(), options: nil)?.first as? PatientViewCell else { return nil }
            guard let patient = tag.Patients.first else { return nil }
            patientTagCell.RenderWith(Object: patient)
            let patientTagView = patientTagCell.contentView
            patientTagView.sizeToFit()
            patientTagView.translatesAutoresizingMaskIntoConstraints = false
            
            let patientViewContainer = Stackview()
            var patientViewSubviews: [UIView] = []
            if containsTagChanges(ForTagData: tags, andTag: tag) {
                guard let tagChangesWarning = Bundle(for: TagChangesWarning.self).loadNibNamed("TagChangesWarning", owner: TagChangesWarning(), options: nil)?.first as? TagChangesWarning else { return nil }
                tagChangesWarning.renderWarning()
                tagChangesWarning.contentView.translatesAutoresizingMaskIntoConstraints = false
                tagChangesWarning.contentView.addConstraint(tagChangesWarning.contentView.heightAnchor.constraint(equalToConstant: tagChangesWarning.frame.height * 2))
                patientViewSubviews.append(tagChangesWarning.contentView)
                returnData.tagChangesWarningView = tagChangesWarning
            }
            
            patientViewSubviews.append(patientTagView)
            patientViewSubviews.append(descriptionView)
            patientViewContainer.initWithViews(patientViewSubviews)
            patientViewContainer.translatesAutoresizingMaskIntoConstraints = false
            returnData.patientDetailsView = patientViewContainer
            topLevelViews.append(patientViewContainer)
            
            if !forTimeline {
                guard let photographerInfo = tag.PhotographerDetails else { return nil }
                guard let photographerInfoView = Bundle(for: PhotographerInfoViewSmall.self).loadNibNamed("PhotographerInfoViewSmall", owner: PhotographerInfoViewSmall(), options: nil)?.first as? PhotographerInfoViewSmall else { return nil }
                photographerInfoView.displayDetails(photographerTagDetails: photographerInfo)
                
                let photographerView = photographerInfoView.contentView
                
                photographerView.translatesAutoresizingMaskIntoConstraints = false
                photographerView.sizeToFit()
                returnData.photographerDetailsView = photographerView
                subviews.append(photographerView)
                
                photographerView.layoutSubviews()
                photographerView.sizeToFit()
            }
            descriptionView.layoutSubviews()
            descriptionView.sizeToFit()
        }
        
        subviews.append(timeView)
        
        returnView.translatesAutoresizingMaskIntoConstraints = false
        returnView.sizeToFit()
        
        if tags.count > 1 && !forTimeline {
            //display a cell saying there's tag history available
            let historyView = UIView()
            let historyLabel = UILabel()
            historyView.translatesAutoresizingMaskIntoConstraints = false
            
            historyView.addSubview(historyLabel)
            historyView.addConstraints([
                historyLabel.centerXAnchor.constraint(equalTo: historyView.centerXAnchor),
                historyLabel.centerYAnchor.constraint(equalTo: historyView.centerYAnchor),
                historyView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
            ])
            historyLabel.textAlignment = .center
            historyLabel.text = AlternateHomeTools.getNSLocalized("view_tag_history", in: "Vector")
            ThemeService.shared().theme.recursiveApply(on: historyView)
            historyLabel.textColor = ThemeService.shared().theme.tintColor
            historyLabel.translatesAutoresizingMaskIntoConstraints = false
            
            subviews.append(historyView)
            returnData.displayTagHistory = true
            returnData.displayTagHistoryView = historyView
        }
        childStackView.initWithViews(subviews)
        topLevelViews.append(childStackView)
        
        returnView.initWithViews(topLevelViews)
        
        returnData.returnView = returnView
        returnView.layoutSubviews()
        returnData.otherViews = childStackView
        childStackView.layoutSubviews()
        childStackView.sizeToFit()
        
        return returnData
    }
}
