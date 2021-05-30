// 
// Copyright 2021 New Vector Ltd
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
import UIKit

/// Dark theme colors. Will be a struct when things are more Swifty.
public class DarkColors: Colors {
    
    public let accent: UIColor = UIColor(rgbHex: 0x0DBD8B)
    
    public let alert: UIColor = UIColor(rgbHex: 0xFF4B55)
    
    public let primaryContent: UIColor = UIColor(rgbHex: 0xFFFFFF)
    
    public let secondaryContent: UIColor = UIColor(rgbHex: 0xA9B2BC)
    
    public let tertiaryContent: UIColor = UIColor(rgbHex: 0x8E99A4)
    
    public let quarterlyContent: UIColor = UIColor(rgbHex: 0x6F7882)
    
    public let separator: UIColor = UIColor(rgbHex: 0x21262C)
    
    public let tile: UIColor = UIColor(rgbHex: 0x394049)
    
    public let navigation: UIColor = UIColor(rgbHex: 0x21262C)
    
    public let background: UIColor = UIColor(rgbHex: 0x15191E)
    
    public let namesAndAvatars: [UIColor] = [
        UIColor(rgbHex: 0x368BD6),
        UIColor(rgbHex: 0xAC3BA8),
        UIColor(rgbHex: 0x03B381),
        UIColor(rgbHex: 0xE64F7A),
        UIColor(rgbHex: 0xFF812D),
        UIColor(rgbHex: 0x2DC2C5),
        UIColor(rgbHex: 0x5C56F5),
        UIColor(rgbHex: 0x74D12C)
    ]
    
    public init() {}
    
}
