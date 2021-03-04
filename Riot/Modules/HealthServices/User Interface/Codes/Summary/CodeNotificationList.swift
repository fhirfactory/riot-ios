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

class CodeNotificationList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 5 {
            return tableView.dequeueReusableCell(withIdentifier: "CodeSummaryCell", for: indexPath)
        }
        return tableView.dequeueReusableCell(withIdentifier: "AlternateCodeSummaryCell", for: indexPath)
    }
    
    @IBOutlet weak var CodesListView: UITableView!
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        UINib(nibName: String(describing: type(of: self)), bundle: nil).instantiate(withOwner: self, options: nil)
    }
    
    let userNotificationCenter = UNUserNotificationCenter.current()

    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "🔵 CODE BLUE TCH RESPOND"
        notificationContent.body = "BLD1 L2  WARD 4A  BED 12"
        notificationContent.categoryIdentifier = "CODE_NOTIFICATION"
        //notificationContent.badge = NSNumber(value: 3)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 1 {
            self.show(CodeDetailDemo(), sender: self)
        }
        let demovc = AlternateCodeDetailDemo()
        self.show(demovc, sender: self)
    }
    
    override func viewDidLoad() {
        CodesListView.register(UINib(nibName: "CodeSummaryCell", bundle: nil), forCellReuseIdentifier: "CodeSummaryCell")
        CodesListView.register(UINib(nibName: "AlternateCodeSummaryCell", bundle: nil), forCellReuseIdentifier: "AlternateCodeSummaryCell")
        requestNotificationAuthorization()
        sendNotification()
    }
    
}
