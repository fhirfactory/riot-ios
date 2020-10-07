// 
// Copyright 2020 Health Directorate
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

class SettingsViewControllerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_192985_viewSourceIsHidden() throws {
        /// Given I am a Room Member
        /// AND I have selected the Room
        /// When have selected a message or file
        /// Then the following OOTB functions are removed/unavailable, including
        ///     View Source (of the selected Message)
        ///     View Decrypted Source (of the selected Message)
        ///     Report Content (of the selected Message)
        ///     Encryption Information (of the selected Message)
        ///     Session Information (of the selected Message)
        
        XCTAssert(BuildSettings.messageDetailsAllowViewSource == false)  // Note this is used to prevent both view source and view decrypted source
        XCTAssert(BuildSettings.messageDetailsAllowReportContent == false)
        XCTAssert(BuildSettings.messageDetailsAllowViewEncryptionInformation == false) // Note this is used to prevent both encryption and session information 
        
    }
    
    func test_192990_preventManageIntegrations() throws {
        /// Given I am a Room Member
        /// When I select the Room
        /// Then the following OOTB functions are removed/unavailable, including
        ///     Manage Integrations
        
        XCTAssert(UserDefaults.standard.bool(forKey: "matrixApps") == false)
        
    }

}

