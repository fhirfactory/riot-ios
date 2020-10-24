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

class AlternateRoomCreationFlowAddMembersController : UIViewController{
    @IBAction func Trigger(_ sender: Any) {
        animateSearchResultView()
    }
    @IBOutlet weak var SearchResultContainerView: UIView!
    @IBOutlet weak var SearchControllerTopConstraint: NSLayoutConstraint!
    static func nib() -> UINib! {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: nil, action: nil)
        self.navigationItem.title = AlternateHomeTools.getNSLocalized("room_creation_add_members", in: "Vector")
        let search = SearchViewSection()
        search.initWithTitles(["Roles","People"], viewControllers: [SelectableFilteredSearchController(), SelectableFilteredSearchController()], defaultSelected: 0)
        search.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: search.view.frame.height)
        //self.navigationController?.show(search, sender: self)
        SearchResultContainerView.addSubview(search.view)
    }
    func animateSearchResultView(){
        view.layoutIfNeeded()
        SearchControllerTopConstraint.constant = 100

        UIView.animate(withDuration: 10.0, animations: {
             self.view.layoutIfNeeded()
        })
    }
}
