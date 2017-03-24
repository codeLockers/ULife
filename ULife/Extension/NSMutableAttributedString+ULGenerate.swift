//
//  NSMutableAttributedString+ULGenerate.swift
//  ULife
//
//  Created by codeLocker on 2017/3/23.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    
    /// 设置富文本字体大小
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - range: 区间
    /// - Returns: 富文本
    func ul_setText(font:UIFont, inRange range:NSRange) -> NSMutableAttributedString {
        self.addAttributes([NSFontAttributeName:font], range: range)
        return self
    }
    
    func ul_setText(color:UIColor, inRange range:NSRange) -> NSMutableAttributedString {
        self.addAttributes([NSForegroundColorAttributeName:color], range: range)
        return self
    }
    
    func ul_setText(backgroundColor:UIColor, inRange range:NSRange) -> NSMutableAttributedString {
        self.addAttributes([NSBackgroundColorAttributeName:backgroundColor], range: range)
        return self
    }
    
    func ul_setText(strokeColor:UIColor, strokeWidth:CGFloat, inRange range:NSRange) -> NSMutableAttributedString {
        self.addAttributes([NSStrokeColorAttributeName:strokeColor], range: range)
        self.addAttributes([NSStrokeWidthAttributeName:strokeWidth], range: range)
        return self
    }
    
    func ul_setText(shadow:NSShadow, inRange range:NSRange) -> NSMutableAttributedString {
        self.addAttributes([NSShadowAttributeName:shadow], range: range)
        return self
    }
    
    func ul_setTextDeleteLine(style:NSUnderlineStyle, color:UIColor, inRange range:NSRange) -> NSMutableAttributedString {
        self.addAttributes([NSStrikethroughStyleAttributeName:style], range: range)
        self.addAttributes([NSStrikethroughColorAttributeName:color], range: range)
        return self
    }
    
    func ul_setTextUnderLine(style:NSUnderlineStyle, color:UIColor, inRange range:NSRange) -> NSMutableAttributedString {
        self.addAttributes([NSUnderlineStyleAttributeName:style], range: range)
        self.addAttributes([NSUnderlineColorAttributeName:color], range: range)
        return self
    }
    
    func ul_setText(kern:CGFloat, inRange range:NSRange) -> NSMutableAttributedString {
        self.addAttributes([NSKernAttributeName:kern], range: range)
        return self
    }
    
    func ul_setText(paragraphStyle:NSParagraphStyle, inRange range:NSRange) -> NSMutableAttributedString {
        self.addAttributes([NSParagraphStyleAttributeName:paragraphStyle], range: range)
        return self
    }
    
    func ul_setText(lineSpace:CGFloat, breakModel:NSLineBreakMode, inRange range:NSRange) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = breakModel
        style.lineSpacing = lineSpace
        return self.ul_setText(paragraphStyle: style, inRange: range)
    }
    
    func ul_setText(effect:String, inRange range:NSRange) -> NSMutableAttributedString {
        self.addAttributes([NSTextEffectAttributeName:effect], range: range)
        return self
    }
    
    func ul_setText(ligature:Bool, inRange range:NSRange) -> NSMutableAttributedString {
        self.addAttributes([NSLigatureAttributeName:ligature], range: range)
        return self
    }
    
    func ul_setText(obliqueness:CGFloat, inRange range:NSRange) -> NSMutableAttributedString {
        self.addAttributes([NSObliquenessAttributeName:obliqueness], range: range)
        return self
    }
    
    func ul_setText(baseLine offset:CGFloat, inRange range:NSRange) -> NSMutableAttributedString {
        self.addAttributes([NSBaselineOffsetAttributeName:offset], range: range)
        return self
    }
    
    func ul_setText(expansion:CGFloat, inRange range:NSRange) -> NSMutableAttributedString {
        self.addAttributes([NSExpansionAttributeName:expansion], range: range)
        return self
    }
    
    func ul_setText(url:NSURL, inRange range:NSRange) -> NSMutableAttributedString {
        self.addAttributes([NSLinkAttributeName:url], range: range)
        return self
    }
    
    func ul_setText(attacment:NSTextAttachment, atIndex index:Int) -> NSMutableAttributedString {
        let str = NSAttributedString.init(attachment: attacment)
        self.insert(str, at: index)
        return self
    }
    
    func ul_setText(attribute:Dictionary<String, Any>, inRange range:NSRange) -> NSMutableAttributedString {
        self.addAttributes(attribute, range: range)
        return self
    }
}

