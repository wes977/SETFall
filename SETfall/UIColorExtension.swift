//
//  UIColorExtension.swift
//  SETfall
//
//  Created by Student on 2016-10-24.
//  Copyright © 2016 WesNet. All rights reserved.
//

import UIKit
// so I canuse HEX 
extension UIColor {
    convenience init (hex:Int,alpha: CGFloat = 1.0){
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red:red,green:green,blue: blue ,alpha: alpha)
        
    }
}
