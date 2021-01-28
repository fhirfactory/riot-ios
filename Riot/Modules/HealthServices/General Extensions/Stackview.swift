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

class Stackview: UIView {
    var stackedViews: [UIView] = []
    
    //Must be in order (top -> bottom)
    @objc func initWithViews(_ views: [UIView]) {
        for view in stackedViews {
            view.removeFromSuperview()
        }
        stackedViews = []
        guard let firstView = views.first else { return }
        addSubview(firstView)
        addConstraints([
            firstView.leadingAnchor.constraint(equalTo: leadingAnchor),
            firstView.trailingAnchor.constraint(equalTo: trailingAnchor),
            firstView.topAnchor.constraint(equalTo: topAnchor)
        ])
        stackedViews.append(firstView)
        if 1 <= views.count - 1 {
            for view in views[1..<views.count - 1] {
                addSubview(view)
                guard let last = stackedViews.last else { return }
                addConstraints([
                    view.leadingAnchor.constraint(equalTo: leadingAnchor),
                    view.trailingAnchor.constraint(equalTo: trailingAnchor),
                    view.topAnchor.constraint(equalTo: last.bottomAnchor)
                ])
                stackedViews.append(view)
            }
        }
        guard let last = stackedViews.last else { return }
        guard let lastView = views.last else { return }
        if !subviews.contains(lastView) { //if we haven't already added the last view in our list (there's more than one item in our list)
            addSubview(lastView)
            addConstraints([
                lastView.topAnchor.constraint(equalTo: last.bottomAnchor),
                lastView.leadingAnchor.constraint(equalTo: leadingAnchor),
                lastView.trailingAnchor.constraint(equalTo: trailingAnchor),
                lastView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        } else { //if there was only one item in our list, we've already added three of the four constraints earlier
            addConstraints([
                lastView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        layoutIfNeeded()
    }
}
