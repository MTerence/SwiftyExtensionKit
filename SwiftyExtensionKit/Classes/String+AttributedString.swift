//
//  String+AttributedString.swift
//  ILearn
//
//  Created by Ternence on 2022/6/12.
//

import Foundation
import UIKit

extension String {
    
    /// String -> NSAttributedString
    /// - Parameters:
    ///   - color: UIColor
    ///   - font: UIFont
    ///   - lineSpace: 行间距
    ///   - kern: 字间距
    ///   - aligment: NSTextAlignment
    /// - Returns: NSAttributedString
    public func attributed(with color: UIColor?,
                          font: UIFont?,
                          lineSpace: CGFloat?,
                          kern: CGFloat?,
                          aligment: NSTextAlignment?) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let pargraph = NSMutableParagraphStyle()
        
        if let color = color {
            attributedString.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: self.count))
        }
        
        if let font = font {
            attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: self.count))
        }
        
        if let kern = kern {
            attributedString.addAttribute(.kern, value: kern, range: NSRange(location: 0, length: self.count))
        }
        
        if let lineSpace = lineSpace {
            pargraph.lineSpacing = lineSpace

        }
        if let aligment = aligment {
            pargraph.alignment = aligment
        }
        
        attributedString.addAttribute(.paragraphStyle, value: pargraph, range: NSRange(location: 0, length: self.count))
        
        return attributedString
    }
    
    static func attributed(with totleText: String,
                           replaced texts: [String],
                           colors: [UIColor], fonts: [UIFont],
                           links: [String]) -> NSAttributedString {
        let text = String(format: totleText.replacingOccurrences(of: "%s", with: "%@"), texts.first!, texts.last!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributedString = NSMutableAttributedString(string: text,
                                                         attributes: [.font: fonts.first,
                                                                      .foregroundColor: colors.first,
                                                                      .kern: 0.0, .paragraphStyle:paragraphStyle])

        if let range = text.range(of: texts.first!) {
            let location = text.distance(from: text.startIndex, to: range.lowerBound)
            attributedString.addAttributes([.link: "terms://",
                                            .foregroundColor:colors.last!],
                                           range: NSRange(location: location, length: texts.first!.count))
        }
        
        if let range = text.range(of: texts.last!) {
            let location = text.distance(from: text.startIndex, to: range.lowerBound)
            attributedString.addAttributes([.link: "privacy://",
                                            .foregroundColor:colors.last],
                                           range: NSRange(location: location, length: texts.last!.count))
        }
        return attributedString
    }
}

extension String {
    public func calculateSize(with maxSize: CGSize, font: UIFont? = nil ) -> CGSize {
        if let font = font {
            let size = (self as NSString).boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font], context: nil).size
            return CGSize(width: ceil(size.width), height: ceil(size.height))
        }
        
        let size = (self as NSString).boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: nil, context: nil).size
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
}

extension NSMutableAttributedString {
    public func calculateSize(with maxSize: CGSize) -> CGSize {
        let size = self.boundingRect(with: maxSize, context: nil)
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
    
    public func sizeLabelToFix(with maxSize: CGSize, numberOfLines: NSInteger = 0) -> CGSize {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: maxSize.width, height: maxSize.height))
        label.attributedText = self
        label.numberOfLines = numberOfLines
        label.sizeToFit()
        let resultSize = label.frame.size
        return CGSize(width: min(maxSize.width, ceil(resultSize.width)),
                      height: min(maxSize.height, ceil(resultSize.height)))
    }
}
