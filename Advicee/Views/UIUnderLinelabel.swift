//
//  UIUnderLinelabel.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 11/05/2021.
//

import UIKit

class UIUnderLinelabel: UILabel {
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let attributedText = NSMutableAttributedString(string: text)
            let range = NSRange(location: 0, length: text.count)
            attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            self.attributedText = attributedText
            
        }
    }
}
