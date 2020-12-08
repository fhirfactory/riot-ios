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

class MessageImageView: MessageContentView {
    @IBOutlet weak var ImageContent: MXKImageView!
    override class func nib() -> UINib! {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    override internal func renderData(_ celldata: MXKRoomBubbleCellData, _ width: CGFloat) {
        self.subviews.forEach { (v) in
            v.removeFromSuperview()
        }
        self.addSubview(ImageContent)
        let attachment = celldata.attachment
        ImageContent.mediaFolder = celldata.roomId
        ImageContent.setAttachmentThumb(attachment)
        ImageContent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageClicked)))
        self.removeConstraints(self.constraints)
        ImageContent.removeConstraints(ImageContent.constraints)
        self.addConstraint(ImageContent.leadingAnchor.constraint(equalTo: self.leadingAnchor))
        self.addConstraint(ImageContent.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        self.addConstraint(ImageContent.bottomAnchor.constraint(equalTo: self.bottomAnchor))
        self.addConstraint(ImageContent.topAnchor.constraint(equalTo: self.topAnchor))
        
        self.addConstraint(self.heightAnchor.constraint(equalToConstant: MessageImageView.calculateHeight(forWidth: width, andCellData: celldata)))
        self.addConstraint(self.widthAnchor.constraint(equalToConstant: MessageImageView.calculateWidth(fromMaxWidth: width, andCellData: celldata)))
        
        ImageContent.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        guard let URL = celldata.attachment.contentURL else { return }
        
        Services.ImageTagDataService().LookupTagInfoFor(URL: URL) { (tagInfo) in
            guard let tag = tagInfo.last else { return }
            guard let patient = tag?.Patients.first else { return }
            
            guard let patientTagView = Bundle(for: type(of: self)).loadNibNamed("PatientViewCell", owner: PatientViewCell(), options: nil)?.first as? PatientViewCell else { return }
            patientTagView.RenderWith(Object: patient)
            let patientTagViewContent = patientTagView.contentView
            patientTagViewContent.translatesAutoresizingMaskIntoConstraints = false
            
            patientTagViewContent.layoutIfNeeded()
            self.addSubview(patientTagViewContent)
            
            self.addConstraint(self.trailingAnchor.constraint(equalTo: patientTagViewContent.trailingAnchor))
            patientTagViewContent.addConstraint(patientTagViewContent.heightAnchor.constraint(equalToConstant: 80))
            self.addConstraint(self.leadingAnchor.constraint(equalTo: patientTagViewContent.leadingAnchor))
            self.addConstraint(patientTagViewContent.bottomAnchor.constraint(equalTo: ImageContent.bottomAnchor))
            
            patientTagViewContent.alpha = 0.7
            patientTagViewContent.sizeToFit()
            
            tagData = tag
            
            let taprecognizer = UITapGestureRecognizer(target: self, action: #selector(tagTapped))
            patientTagViewContent.addGestureRecognizer(taprecognizer)
            
            self.layoutIfNeeded()
        }
         
    }
    
    var tagData: TagData!
    @objc func tagTapped() {
        let patientTaggingController = PatientTaggingViewController()
        guard let imagedata = ImageContent.image.pngData() as NSData? else { return }
        patientTaggingController.setImage(To: imagedata) { (tagdata) in
            
        }
        guard let datasource = delegate.delegate as? MXKRoomDataSource else { return }
        guard let viewcontroller = datasource.delegate as? MXKRoomViewController else { return }
        patientTaggingController.loadExistingTagData(tagData)
        
        viewcontroller.show(patientTaggingController, sender: viewcontroller)
    }
    @IBAction private func imageClicked() {
        let d = delegate
        let dd = d?.delegate
        if let ddd = dd as? MXKRoomDataSource {
            if let dddd = ddd.delegate as? MXKRoomViewController {
                dddd.showAttachment(in: d)
            }
        }
        delegate.delegate.cell(delegate, didRecognizeAction: kMXKRoomBubbleCellTapOnAttachmentView, userInfo: nil)
    }
    override func applyTheStyle(_ theme: Theme) {
        self.backgroundColor = .none
    }
    override class func reuseIdentifier() -> String {
        return "MessageImageView"
    }
    class func calculateHeight(forWidth width: CGFloat, andCellData bubbleCell: MXKRoomBubbleCellData) -> CGFloat {
        let aspectRatio = bubbleCell.contentSize.height / bubbleCell.contentSize.width
        return aspectRatio * calculateWidth(fromMaxWidth: width, andCellData: bubbleCell)
    }
    
    //this is here so it's easy to change options pertaining to image sizing
    class func calculateWidth(fromMaxWidth width: CGFloat, andCellData bubbleCell: MXKRoomBubbleCellData) -> CGFloat {
        return width * 0.9
    }
}
