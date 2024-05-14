//
//  Attribute.swift
//  Counter
//
//  Created by Rihab Mehboob on 01/05/2023.
//

import Foundation
import UIKit

class Attribute {
    
    // Make the text font etc
    public static func outline(string: String, font: UIFont, outlineSize: Float, textColor: UIColor, outlineColor: UIColor) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string, attributes: outlineAttributes(font: font, outlineSize: outlineSize, textColor: textColor, outlineColor: outlineColor))
    }
    
    // Attributes for text
    public static func outlineAttributes(font: UIFont, outlineSize: Float, textColor: UIColor, outlineColor: UIColor) -> [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.strokeColor : outlineColor,
            NSAttributedString.Key.foregroundColor : textColor,
            NSAttributedString.Key.strokeWidth : -outlineSize,
            NSAttributedString.Key.font : font
        ]
    }
    
    public static func outlineStrike(string: String, font: UIFont, outlineSize: Float, textColor: UIColor, outlineColor: UIColor) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string, attributes: outlineAttributesStrike(font: font, outlineSize: outlineSize, textColor: textColor, outlineColor: outlineColor))
    }
    
    public static func outlineAttributesStrike(font: UIFont, outlineSize: Float, textColor: UIColor, outlineColor: UIColor) -> [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.strokeColor : outlineColor,
            NSAttributedString.Key.foregroundColor : textColor,
            NSAttributedString.Key.strokeWidth : -outlineSize,
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.strikethroughStyle : 1, // NSUnderlineStyle.single,
            NSAttributedString.Key.strikethroughColor : UIColor.black
        ]
    }
    
    public static func outlineUnder(string: String, font: UIFont, outlineSize: Float, textColor: UIColor, outlineColor: UIColor) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string, attributes: outlineAttributesUnder(font: font, outlineSize: outlineSize, textColor: textColor, outlineColor: outlineColor))
    }
    
    public static func outlineAttributesUnder(font: UIFont, outlineSize: Float, textColor: UIColor, outlineColor: UIColor) -> [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.strokeColor : outlineColor,
            NSAttributedString.Key.foregroundColor : textColor,
            NSAttributedString.Key.strokeWidth : -outlineSize,
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.underlineStyle : 1,
            NSAttributedString.Key.underlineColor : outlineColor
        ]
    }
}
