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
}

@objc class PatientViewCellObjectiveC: NSObject {
    @objc static func getPatientViewCell(ForTagData tag: TagData) -> PatientViewCellData? {
        let returnData = PatientViewCellData()
        let returnView = UIView()
        guard let descriptionCell = Bundle(for: ImageDescriptionCell.self).loadNibNamed("ImageDescriptionCell", owner: ImageDescriptionCell(), options: nil)?.first as? ImageDescriptionCell else { return nil}
        let viewModel = PatientTaggingViewController.produceViewModel(fromTagData: tag)
        descriptionCell.render(viewModel: viewModel)
        descriptionCell.setAsReadOnly()
        descriptionCell.sizeToFit()
        let descriptionView = descriptionCell.contentView
        returnView.addSubview(descriptionView)
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.sizeToFit()
        returnData.descriptionView = descriptionView
        returnView.addConstraints([
                                    descriptionView.leadingAnchor.constraint(equalTo: returnView.leadingAnchor),
                                    descriptionView.trailingAnchor.constraint(equalTo: returnView.trailingAnchor),
                                    descriptionView.topAnchor.constraint(equalTo: returnView.topAnchor)
        ])
        
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
            returnView.addSubview(patientTagView)
            returnView.addConstraints([
                                       patientTagView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor),
                                       patientTagView.leadingAnchor.constraint(equalTo: returnView.leadingAnchor),
                                       patientTagView.trailingAnchor.constraint(equalTo: returnView.trailingAnchor)
            ])
            
            photographerView.translatesAutoresizingMaskIntoConstraints = false
            photographerView.sizeToFit()
            returnData.photographerDetailsView = photographerView
            returnView.addSubview(photographerView)
            returnView.addConstraints([
                                        photographerView.topAnchor.constraint(equalTo: patientTagView.bottomAnchor),
                                        photographerView.leadingAnchor.constraint(equalTo: returnView.leadingAnchor),
                                        photographerView.trailingAnchor.constraint(equalTo: returnView.trailingAnchor),
                                        photographerView.bottomAnchor.constraint(equalTo: returnView.bottomAnchor)
            ])
        } else {
            returnView.addConstraint(descriptionView.bottomAnchor.constraint(equalTo: returnView.bottomAnchor))
        }
        returnView.translatesAutoresizingMaskIntoConstraints = false
        returnView.sizeToFit()
        
        returnData.returnView = returnView
        
        return returnData
    }
}
