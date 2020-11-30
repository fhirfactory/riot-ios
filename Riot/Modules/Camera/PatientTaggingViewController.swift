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
    var taggedPatients: [PatientModel] = []
    var PhotoSavedEventHandler: (([PatientModel]) -> Void)?
    @IBAction private func SaveAction(_ sender: Any) {
        if let completion = PhotoSavedEventHandler {
            if taggedPatients.count > 0 {
                navigationController?.popViewController(animated: true)
                completion(taggedPatients)
            } else {
                let alert = UIAlertController(title: AlternateHomeTools.getNSLocalized("media_tag_save_non_patient_media", in: "Vector"), message: AlternateHomeTools.getNSLocalized("media_tag_untagged_alert_description", in: "Vector"), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: AlternateHomeTools.getNSLocalized("no", in: "Vector"), style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: AlternateHomeTools.getNSLocalized("yes", in: "Vector"), style: .default, handler: { (a) in
                    self.navigationController?.popViewController(animated: true)
                    completion(self.taggedPatients)
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
            self.taggedPatients.append(patient)
            self.tableView.reloadData()
            self.updateSelections()
        }
        self.present(patientTaggingVC, animated: true, completion: nil)
    }
    
    var patientTaggingViewModel: PatientTaggingViewModel = PatientTaggingViewModel()
    
    func updateSelections() {
        self.tableView.isHidden = false
        if taggedPatients.count > 0 {
            //self.tableView.isHidden = false
            self.TagPatientButton.isHidden = true
            self.SaveButton.setTitle(AlternateHomeTools.getNSLocalized("media_tag_save_patient_media", in: "Vector"), for: .normal)
        } else {
            //self.tableView.isHidden = true
            self.TagPatientButton.isHidden = false
            self.SaveButton.setTitle(AlternateHomeTools.getNSLocalized("media_tag_save_non_patient_media", in: "Vector"), for: .normal)
        }
    }
    
    var image: UIImage!
    
    static func nib() -> UINib! {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    @objc public func setImage(To imageData: NSData, WithHandler eventHandler: (([PatientModel]) -> Void)?) {
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
        return taggedPatients.count > 0 ? taggedPatients.count + 2 : 1
    }
    
    var resignDescriptionCellResponder: (() -> Void)?
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        (resignDescriptionCellResponder ?? {})()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > taggedPatients.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotographerDetails", for: indexPath) as? PhotographerDetails else {return UITableViewCell()}
            cell.applyTheme()
            cell.nearestViewController = self
            cell.setRole(to: patientTaggingViewModel.role)
            cell.setChangeHandler { (r) in
                self.patientTaggingViewModel.role = r
            }
            return cell
        } else if indexPath.row == taggedPatients.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageDescriptionCell", for: indexPath) as? ImageDescriptionCell else {return UITableViewCell()}
            cell.render(viewModel: patientTaggingViewModel)
            resignDescriptionCellResponder = cell.forceResignFirstResponder
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PatientViewCell", for: indexPath) as? PatientViewCell else {return UITableViewCell()}
        cell.RenderWith(Object: taggedPatients[indexPath.row])
        
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
        guard indexPath.row < taggedPatients.count else { return }
        let data = taggedPatients[indexPath.row]
        taggedPatients.removeAll(where: {(x) in x.URN == data.URN})
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        updateSelections()
    }
}
