// 
// Copyright 2020 Vector Creations Ltd
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

import UIKit

@IBDesignable class Dot: UIView {

    @IBInspectable var mainColor: UIColor = UIColor.blue {
        didSet {
             print("mainColor was set here")
        }
    }

    @IBInspectable var ringColor: UIColor = UIColor.orange {
         didSet {
             print("bColor was set here")
        }
    }

    @IBInspectable var ringThickness: CGFloat = 4 {
        didSet {
            print("ringThickness was set here")
        }
    }
    
    @IBInspectable var isSelected: Bool = true
    
    override func draw(_ rect: CGRect) {
        let dotPath = UIBezierPath(ovalIn:rect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = dotPath.cgPath
        shapeLayer.fillColor = mainColor.cgColor
        layer.addSublayer(shapeLayer)
        
        if (isSelected) {
            drawRingFittingInsideView(rect: rect)
        }
    }
    
    internal func drawRingFittingInsideView(rect: CGRect) {
        let hw:CGFloat = ringThickness/2
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: hw,dy: hw) )
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = ringColor.cgColor
        shapeLayer.lineWidth = ringThickness
        layer.addSublayer(shapeLayer)
    }
}
