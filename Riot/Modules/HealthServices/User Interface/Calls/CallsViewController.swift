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

@objc class CallsViewController: UIViewController {
    var sections = SegmentedViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        if view.subviews.count > 0 {
            for theview in view.subviews {
                theview.removeFromSuperview()
                theview.isHidden = true
            }
            sections = SegmentedViewController()
        }
        
        AppDelegate.theDelegate().masterTabBarController.title = AlternateHomeTools.getNSLocalized("tab_calls", in: "Vector")
        
        sections.initWithTitles(["Recents", "Dialer"], viewControllers: [RecentCallsList(), DialViewController(nibName: "DialViewController", bundle: Bundle.main)], defaultSelected: 1)
        
        sections.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        view.addSubview(sections.view)
    }
    
    @objc func displayList(_ l: RecentsDataSource) {
        //just to save us from crashing
    }
}
