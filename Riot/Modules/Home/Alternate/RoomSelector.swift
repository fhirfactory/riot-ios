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

class RoomSelector: TabbedHomeViewController {
    static override func nib() -> UINib! {
        UINib(nibName: "TabbedHomeViewController", bundle: Bundle(for: self))
    }
    public var callback: ((MXRoom) -> Void)!
    @objc public func SetCallback(_ callback : @escaping ((MXRoom) -> Void)) {
        self.callback = {(room) in
            //dismiss ourselves (to dismiss the popover view)
            self.dismiss(animated: true, completion: nil)
            callback(room)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.enableCreateRoomButton = false
        super.SelectedRoomHandler = callback
        super.viewWillAppear(animated)
    }
}
