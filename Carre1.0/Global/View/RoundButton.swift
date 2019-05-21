//
//  RoundButton.swift
//  Carre1.0
//
//  Created by Nikolas on 06/04/2019.
//  Copyright © 2019 Nikolas Aggelidis. All rights reserved.
//


import UIKit


@IBDesignable class RoundButton: UIButton {
    
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet {
            
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        
        didSet {
            
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        
        didSet {
            
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
