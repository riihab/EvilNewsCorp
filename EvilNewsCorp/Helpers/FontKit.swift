//
//  FontKit.swift
//  Counter
//
//  Created by Rihab Mehboob on 01/05/2023.
//

import Foundation
import UIKit

class FontKit {
    
    static func roundedFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        let font: UIFont
        
        if #available(iOS 13.0, *) {
            if let descriptor = systemFont.fontDescriptor.withDesign(.default) {
                font = UIFont(descriptor: descriptor, size: fontSize)
            } else {
                font = systemFont
            }
        } else {
            font = systemFont
        }
        
        return font
    }
}
