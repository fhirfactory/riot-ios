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

import XCTest
@testable import Riot

class RoomInputToolbarViewTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_192990_preventSendingStickers() throws {
        /// Given I am a Room Member
        /// When I select the Room
        /// Then the following OOTB functions are removed/unavailable, including
        ///     Send a GIF
        ///     Send a Sticker
        
        XCTAssert(BuildSettings.allowSendingStickers == false) // Sending of GIFs is not enabled for iOS out of the box and does not need specific disabling
        
    }

}
