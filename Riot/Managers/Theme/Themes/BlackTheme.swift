/*
 Copyright 2019 New Vector Ltd

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import UIKit

class BlackTheme: DarkTheme {

    override init() {
        super.init()
        self.identifier = "black"
        self.backgroundColor = UIColor(unused: true, rgb: 0x000000)
        self.baseColor = UIColor(unused: true, rgb: 0x000000)
        self.headerBackgroundColor = UIColor(unused: true, rgb: 0x000000)
        self.headerBorderColor = UIColor(unused: true, rgb: 0x15191E)
    }
}
