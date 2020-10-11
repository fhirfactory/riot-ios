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

class RoomMemberDetailsViewControllerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_192992_disableShowHideAllMessages() throws {
        /// Given I am a Room Member
        /// AND I have opened the Room
        /// AND I have selected Room Details
        /// AND I have selected Members
        /// AND I have selected a Member
        /// When the Member is displayed
        /// Then the Hide / Show all messages from this user is not shown.
        /// Ensure that the Hide / Show all messages from this user function has been removed entirely from the Application.
        
        XCTAssert(BuildSettings.roomParticipantAllowHideAll == false)
        
    }
    
    func test_192995_disableBanRoomMember() throws {
        /// Given I am a Room Member
        /// AND I have selected the Room
        /// AND I have selected the Room Details
        /// AND I have selected Members
        /// AND I am using the IOS or Android Application
        /// When I select a Room Member
        /// Then the following OOTB functions are removed/unavailable, including
        ///    Ban (the selected room member)
        
        XCTAssert(BuildSettings.roomParticipantAllowBan == false)
        
    }

}
