//
//  AttributedTextHelper.swift
//  canvpn
//
//  Created by Can Babaoğlu on 24.12.2022.
//

import UIKit

class AttributedTextHelper {
    
    static func generateAttributedString(text: String, attributes: [NSAttributedString.Key : Any]) -> NSAttributedString {
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    static func replaceAttributedString(attributedString: NSMutableAttributedString,
                                        replaceText: String,
                                        replaceTextAttributes: [NSAttributedString.Key : Any]) -> NSMutableAttributedString {
        
        let range: NSRange = attributedString.mutableString.range(of: replaceText)
        attributedString.addAttributes(replaceTextAttributes, range: range)
        return attributedString
    }
    
//    public static func getPaddingAttributedText (font: UIFont = UIFont.boldSystemFont(ofSize: 14)) -> NSAttributedString {
//        let paddingAttString = AttributedTextHelper.generateAttributedString(text: " ",
//                                                                             attributes: [.font: UIFont.boldSystemFont(ofSize: 14), size: 14.5)])
//        return paddingAttString
//    }

    public static func getRTLFixerUnicodeMarker () -> NSAttributedString {
        let paddingAttString = AttributedTextHelper.generateAttributedString(text: "\u{200E}", attributes: [:])
        return paddingAttString
    }
}

