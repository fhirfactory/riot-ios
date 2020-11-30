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

class MessageTextView: MessageContentView, RendersBubbleComponent {
    func render(component bubbleComponent: MXKRoomBubbleComponent) {
        //TextContent.attributedTextMessage = bubbleComponent.attributedTextMessage
        TextContent.attributedText = bubbleComponent.attributedTextMessage
    }
    
    override var intrinsicContentSize: CGSize {
        return TextContent.intrinsicContentSize
    }
    
    @IBOutlet weak var TextContent: UILabel!
    
    override class func nib() -> UINib! {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    override class func reuseIdentifier() -> String {
        return "MessageTextView"
    }
    override internal func renderData(_ celldata: MXKRoomBubbleCellData) {
        TextContent.attributedText = celldata.attributedTextMessage
    }
    override func applyTheStyle(_ theme: Theme) {
        TextContent.textColor = theme.textPrimaryColor
        self.backgroundColor = .none
    }
}
