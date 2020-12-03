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

class PatientTaggingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var ImagePreview: UIImageView!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var TagPatientTitle: UILabel!
    @IBOutlet weak var PolicyReminder: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var TagPatientButton: UIButton!
    var PhotoSavedEventHandler: ((TagData) -> Void)?
    var patientTaggingViewModel: PatientTaggingViewModel = PatientTaggingViewModel()
    
    @IBAction private func SaveAction(_ sender: Any) {
        if let completion = PhotoSavedEventHandler {
            guard let tagData = PatientTaggingViewController.produceTagData(fromViewModel: patientTaggingViewModel) else { return }
            if patientTaggingViewModel.patients.count > 0 {
                navigationController?.popViewController(animated: true)
                completion(tagData)
            } else {
                let alert = UIAlertController(title: AlternateHomeTools.getNSLocalized("media_tag_save_non_patient_media", in: "Vector"), message: AlternateHomeTools.getNSLocalized("media_tag_untagged_alert_description", in: "Vector"), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: AlternateHomeTools.getNSLocalized("no", in: "Vector"), style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: AlternateHomeTools.getNSLocalized("yes", in: "Vector"), style: .default, handler: { (a) in
                    self.navigationController?.popViewController(animated: true)
                    completion(tagData)
                }))
                present(alert, animated: true, completion: nil)
            }
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    @IBAction private func CancelAction(_ sender: Any) {
    }
    @IBAction private func TagButtonClicked(_ sender: Any) {
        let patientTaggingVC = FilteredSearchPopoverViewController<PatientModel>(withScrollHandler: nil, andViewCellReuseID: "PatientViewCell", andService: Services.PatientService())
        patientTaggingVC.onSelectedCallback = {(patient) in
            self.patientTaggingViewModel.patients.append(patient)
            self.tableView.reloadData()
            self.updateSelections()
        }
        self.present(patientTaggingVC, animated: true, completion: nil)
    }
    
    func loadExistingTagData(_ tagData: TagData?) {
        patientTaggingViewModel = PatientTaggingViewController.produceViewModel(fromTagData: tagData)
        if tableView != nil {
            tableView.reloadData()
        }
    }
    
    static func produceViewModel(fromTagData tagData: TagData?) -> PatientTaggingViewModel {
        let vm = PatientTaggingViewModel()
        guard let td = tagData else { return vm }
        if tagData?.FileContainsPatient ?? false {
            vm.patients = td.Patients
            vm.name = td.PhotographerDetails?.Name
            vm.role = td.PhotographerDetails?.Role
        }
        
        vm.description = td.Description
        return vm
    }
    
    static func produceTagData(fromViewModel patientTaggingViewModel: PatientTaggingViewModel) -> TagData? {
        if patientTaggingViewModel.patients.count > 0 {
            guard let role = patientTaggingViewModel.role else { return nil }
            let photographer = PhotographerTagDetails(withName: patientTaggingViewModel.name, andRole: role)
            return TagData(withPatients: patientTaggingViewModel.patients, Description: patientTaggingViewModel.description, andPhotographer: photographer)
        }
        return TagData(withDescription: patientTaggingViewModel.description)
    }
    
    func updateSelections() {
        self.tableView.isHidden = false
        if patientTaggingViewModel.patients.count > 0 {
            self.TagPatientButton.isHidden = true
            self.SaveButton.setTitle(AlternateHomeTools.getNSLocalized("media_tag_save_patient_media", in: "Vector"), for: .normal)
        } else {
            self.TagPatientButton.isHidden = false
            self.SaveButton.setTitle(AlternateHomeTools.getNSLocalized("media_tag_save_non_patient_media", in: "Vector"), for: .normal)
        }
    }
    
    var image: UIImage!
    
    static func nib() -> UINib! {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    @objc public func setImage(To imageData: NSData, WithHandler eventHandler: ((TagData) -> Void)?) {
        image = UIImage(data: imageData as Data, scale: 1.0)
        PhotoSavedEventHandler = eventHandler
    }
    override func viewWillAppear(_ animated: Bool) {
        //setup themes on everything that needs to be themed
        view.backgroundColor = ThemeService.shared().theme.backgroundColor
        ThemeService.shared().theme.recursiveApply(on: self.view)
        TagPatientTitle.text = AlternateHomeTools.getNSLocalized("media_tag_title", in: "Vector")
        PolicyReminder.text = AlternateHomeTools.getNSLocalized("media_tag_policy", in: "Vector")
        
        ImagePreview.image = image
        tableView.backgroundView?.backgroundColor = ThemeService.shared().theme.backgroundColor
        tableView.backgroundColor = ThemeService.shared().theme.backgroundColor
        tableView.isHidden = true
        tableView.register(UINib(nibName: "PatientViewCell", bundle: nil), forCellReuseIdentifier: "PatientViewCell")
        tableView.register(UINib(nibName: "PhotographerDetails", bundle: nil), forCellReuseIdentifier: "PhotographerDetails")
        tableView.register(UINib(nibName: "ImageDescriptionCell", bundle: nil), forCellReuseIdentifier: "ImageDescriptionCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 73.0
        
        updateSelections()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientTaggingViewModel.patients.count > 0 ? patientTaggingViewModel.patients.count + 2 : 1
    }
    
    var resignDescriptionCellResponder: (() -> Void)?
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        (resignDescriptionCellResponder ?? {})()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > patientTaggingViewModel.patients.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotographerDetails", for: indexPath) as? PhotographerDetails else {return UITableViewCell()}
            cell.applyTheme()
            cell.nearestViewController = self
            cell.setRole(to: patientTaggingViewModel.role)
            cell.setChangeHandler { (r) in
                self.patientTaggingViewModel.role = r
                if self.patientTaggingViewModel.name == nil {
                    guard let session = AppDelegate.theDelegate().mxSessions.first as? MXSession else { return }
                    self.patientTaggingViewModel.name = session.myUser.displayname
                }
            }
            return cell
        } else if indexPath.row == patientTaggingViewModel.patients.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageDescriptionCell", for: indexPath) as? ImageDescriptionCell else {return UITableViewCell()}
            cell.render(viewModel: patientTaggingViewModel)
            resignDescriptionCellResponder = cell.forceResignFirstResponder
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PatientViewCell", for: indexPath) as? PatientViewCell else {return UITableViewCell()}
        cell.RenderWith(Object: patientTaggingViewModel.patients[indexPath.row])
        
        //add the checkmark to indicate the selection
        cell.accessoryType = .checkmark
        cell.tintColor = ThemeService.shared().theme.tintColor
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = ThemeService.shared().theme.selectedBackgroundColor
        cell.backgroundView?.backgroundColor = ThemeService.shared().theme.backgroundColor
        cell.contentView.superview?.backgroundColor = ThemeService.shared().theme.backgroundColor
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < patientTaggingViewModel.patients.count else { return }
        let data = patientTaggingViewModel.patients[indexPath.row]
        patientTaggingViewModel.patients.removeAll(where: {(x) in x.URN == data.URN})
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        updateSelections()
    }
}
