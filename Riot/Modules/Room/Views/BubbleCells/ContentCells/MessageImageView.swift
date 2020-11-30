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
    override internal func renderData(_ celldata: MXKRoomBubbleCellData) {
        let attachment = celldata.attachment
        ImageContent.mediaFolder = celldata.roomId
        ImageContent.setAttachmentThumb(attachment)
        ImageContent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageClicked)))
        frame.size = celldata.contentSize
        backgroundColor = .cyan
        self.removeConstraints(self.constraints)
        ImageContent.removeConstraints(ImageContent.constraints)
        ImageContent.addConstraint(ImageContent.heightAnchor.constraint(equalToConstant: celldata.contentSize.height))
        ImageContent.addConstraint(ImageContent.widthAnchor.constraint(equalToConstant: celldata.contentSize.width))
        self.addConstraint(ImageContent.leadingAnchor.constraint(equalTo: self.leadingAnchor))
        self.addConstraint(ImageContent.topAnchor.constraint(equalTo: self.topAnchor))
    }
    @IBAction private func imageClicked() {
        let d = delegate
        let dd = d?.delegate
        if let ddd = dd as? MXKRoomDataSource {
            if let dddd = ddd.delegate as? MXKRoomViewController {
                dddd.showAttachment(in: d)
            }
        }
        //delegate.delegate.cell(delegate, didRecognizeAction: kMXKRoomBubbleCellTapOnAttachmentView, userInfo: nil)
    }
    override func applyTheStyle(_ theme: Theme) {
        self.backgroundColor = .none
    }
    override class func reuseIdentifier() -> String {
        return "MessageImageView"
    }
}
