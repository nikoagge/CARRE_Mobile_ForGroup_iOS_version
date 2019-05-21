//
//  ColourExtension.swift
//  Carre1.0
//
//  Created by Nikolas on 20/12/2018.
//  Copyright © 2018 Nikolas Aggelidis. All rights reserved.
//


import Foundation
import UIKit


extension UIColor {
    
    
    static func rgbWithAlphaSetTo1(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }

    
    static func rgbWithAlphaSetTo255(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 255)
    }
}
