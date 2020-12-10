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
}

@objc class PatientViewCellObjectiveC: NSObject {
    @objc static func getPatientViewCell(ForTagData tags: [TagData]) -> PatientViewCellData? {
        let returnData = PatientViewCellData()
        let returnView = Stackview()
        let childStackView = Stackview()
        childStackView.translatesAutoresizingMaskIntoConstraints = false
        
        var topLevelViews: [UIView] = []
        var subviews: [UIView] = []
        
        guard let tag = tags.last else { return nil }
        guard let descriptionCell = Bundle(for: ImageDescriptionCell.self).loadNibNamed("ImageDescriptionCell", owner: ImageDescriptionCell(), options: nil)?.first as? ImageDescriptionCell else { return nil}
        let viewModel = PatientTaggingViewController.produceViewModel(fromTagData: tag)
        descriptionCell.render(viewModel: viewModel)
        descriptionCell.setAsReadOnly()
        descriptionCell.sizeToFit()
        let descriptionView = descriptionCell.contentView
        subviews.append(descriptionView)
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        returnData.descriptionView = descriptionView
        
        guard let timeCell = Bundle(for: DateTakenViewCell.self).loadNibNamed("DateTakenViewCell", owner: DateTakenViewCell(), options: nil)?.first as? DateTakenViewCell else { return nil}
        timeCell.RenderWith(Object: tag.TakenDate)
        let timeView = timeCell.contentView
        subviews.append(timeView)
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
            returnData.patientDetailsView = patientTagView
            
            guard let photographerInfo = tag.PhotographerDetails else { return nil }
            guard let photographerInfoView = Bundle(for: PhotographerDetails.self).loadNibNamed("PhotographerDetails", owner: PhotographerDetails(), options: nil)?.first as? PhotographerDetails else { return nil }
            photographerInfoView.displayDetails(photographerTagDetails: photographerInfo)
            
            let photographerView = photographerInfoView.contentView
            
            patientTagView.translatesAutoresizingMaskIntoConstraints = false
            topLevelViews.append(patientTagView)
            
            photographerView.translatesAutoresizingMaskIntoConstraints = false
            photographerView.sizeToFit()
            returnData.photographerDetailsView = photographerView
            subviews.append(photographerView)
            
            photographerView.layoutSubviews()
            descriptionView.layoutSubviews()
            photographerView.sizeToFit()
            descriptionView.sizeToFit()
        }
        returnView.translatesAutoresizingMaskIntoConstraints = false
        returnView.sizeToFit()
        
        if tags.count > 1 {
            returnData.displayTagHistory = true
        }
        
        if tags.count > 1 {
            //only worry about one previous tag.
            if let previousTag = tags.reversed().last { (t) -> Bool in
                t.Patients != tag.Patients && t.Patients.count > 0
            } {
                let paginator = UIView()
                paginator.translatesAutoresizingMaskIntoConstraints = false
                paginator.backgroundColor = .white
                subviews.append(paginator)
                
                let separator = UIView()
                separator.translatesAutoresizingMaskIntoConstraints = false
                separator.backgroundColor = ThemeService.shared().theme.textPrimaryColor
                paginator.addSubview(separator)
                
                let paginatorLabel = UILabel()
                paginatorLabel.textColor = ThemeService.shared().theme.headerTextPrimaryColor
                paginatorLabel.text = "Previously Tagged"
                paginatorLabel.textAlignment = .center
                paginatorLabel.translatesAutoresizingMaskIntoConstraints = false
                paginator.addSubview(paginatorLabel)
                
                paginator.addConstraints([
                    separator.centerXAnchor.constraint(equalTo: paginator.centerXAnchor),
                    separator.widthAnchor.constraint(equalTo: paginator.widthAnchor, multiplier: 0.7),
                    separator.heightAnchor.constraint(equalToConstant: 1),
                    separator.topAnchor.constraint(equalTo: paginator.topAnchor, constant: 5),
                    
                    paginatorLabel.centerXAnchor.constraint(equalTo: separator.centerXAnchor),
                    paginatorLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 5),
                    paginator.bottomAnchor.constraint(equalTo: paginatorLabel.bottomAnchor, constant: 5)
                ])
                
                
                
                guard let patientTagCell = Bundle(for: PatientViewCell.self).loadNibNamed("PatientViewCell", owner: PatientViewCell(), options: nil)?.first as? PatientViewCell else { return nil }
                guard let patient = previousTag.Patients.first else { return nil }
                patientTagCell.RenderWith(Object: patient)
                let patientTagView = patientTagCell.contentView
                patientTagView.translatesAutoresizingMaskIntoConstraints = false
                subviews.append(patientTagView)
            }
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
