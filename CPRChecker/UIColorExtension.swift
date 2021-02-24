//
//  UIColor.swift
//  CPRChecker
//
//  Created by KEN on 2019/11/08.
//  Copyright © 2019 KEN. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    class func randomColor(_ alpha : CGFloat) -> UIColor {
        return UIColor(hue: randomColorComponent(), saturation: 1, brightness: 1, alpha: alpha)
    }
    
    class func randomColorComponent() -> CGFloat {
        return CGFloat(Double(arc4random_uniform(255))/255.0)
    }
}

