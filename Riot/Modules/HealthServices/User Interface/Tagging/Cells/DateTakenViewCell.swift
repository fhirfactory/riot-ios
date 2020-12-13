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

class DateTakenViewCell: QueryTableViewCell<Date> {
    @IBOutlet weak var TakenTitle: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var DateValueLabel: UILabel!
    @IBOutlet weak var TimeValueLabel: UILabel!
    
    override func RenderWith(Object value: Date) {
        super.RenderWith(Object: value)
        ThemeService.shared().theme.recursiveApply(on: self.contentView)
        TakenTitle.text = AlternateHomeTools.getNSLocalized("taken", in: "Vector")
        DateLabel.text = AlternateHomeTools.getNSLocalized("date", in: "Vector")
        TimeLabel.text = AlternateHomeTools.getNSLocalized("time", in: "Vector")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        DateValueLabel.text = dateFormatter.string(from: value)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        TimeValueLabel.text = timeFormatter.string(from: value)
    }
}
