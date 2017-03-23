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
}


////
////  NSMutableAttributedString+FCInitialize.m
////  XZCategory
////
////  Created by 徐章 on 16/7/7.
////  Copyright © 2016年 徐章. All rights reserved.
////
//
//#import "NSMutableAttributedString+FCInitialize.h"
//
//@implementation NSMutableAttributedString (Category)
//
//- (NSMutableAttributedString *)fc_setTextWithColor:(UIColor *)color inRange:(NSRange)range{
//    
//    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
//    return self;
//    }
//    
//    - (NSMutableAttributedString *)fc_setTextWithFont:(UIFont *)font inRange:(NSRange)range{
//        
//        [self addAttribute:NSFontAttributeName value:font range:range];
//        return self;
//        }
//        
//        - (NSMutableAttributedString *)fc_setTextWithBackgroundColor:(UIColor *)color inRange:(NSRange)range{
//            
//            [self addAttribute:NSBackgroundColorAttributeName value:color range:range];
//            return self;
//            }
//            
//            - (NSMutableAttributedString *)fc_setTextWithStrokeColor:(UIColor *)color strokeWidth:(CGFloat)width inRange:(NSRange)range{
//                
//                [self addAttribute:NSStrokeColorAttributeName value:color range:range];
//                [self addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithFloat:width] range:range];
//                return self;
//                }
//                
//                - (NSMutableAttributedString *)fc_setTextWithShadow:(NSShadow *)shadow inRange:(NSRange)range{
//                    
//                    [self addAttribute:NSShadowAttributeName value:shadow range:range];
//                    return self;
//                    }
//                    
//                    - (NSMutableAttributedString *)fc_setTextWithDeleteLine:(NSUnderlineStyle)lineStyle color:(UIColor *)color inRange:(NSRange)range{
//                        
//                        [self addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:lineStyle] range:range];
//                        [self addAttribute:NSStrikethroughColorAttributeName value:color range:range];
//                        return self;
//                        
//                        }
//                        
//                        - (NSMutableAttributedString *)fc_setTextWithUnderLine:(NSUnderlineStyle)lineStyle color:(UIColor *)color inRange:(NSRange)range{
//                            
//                            [self addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:lineStyle] range:range];
//                            [self addAttribute:NSUnderlineColorAttributeName value:color range:range];
//                            return self;
//                            }
//                            - (NSMutableAttributedString *)fc_setTextWithKern:(CGFloat)kern inRange:(NSRange)range{
//                                
//                                [self addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:kern] range:range];
//                                return self;
//                                }
//                                
//                                - (NSMutableAttributedString *)fc_setTextWithParagraphStyle:(NSParagraphStyle *)paragraphStyle inRange:(NSRange)range{
//                                    
//                                    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
//                                    return self;
//                                    }
//                                    
//                                    - (NSMutableAttributedString *)fc_setTextWithLineSpace:(CGFloat)lineSpace breakMode:(NSLineBreakMode)breakMode inRange:(NSRange)range{
//                                        
//                                        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//                                        style.lineBreakMode = breakMode;
//                                        style.lineSpacing = lineSpace;
//                                        
//                                        return [self fc_setTextWithParagraphStyle:style inRange:range];
//                                        }
//                                        
//                                        - (NSMutableAttributedString *)fc_setTextWithEffect:(NSString *)effect inRange:(NSRange)range{
//                                            
//                                            [self addAttribute:NSTextEffectAttributeName value:effect range:range];
//                                            return self;
//                                            }
//                                            
//                                            - (NSMutableAttributedString *)fc_setTextWithLigature:(BOOL)isLigature inRange:(NSRange)range{
//                                                
//                                                [self addAttribute:NSLigatureAttributeName value:[NSNumber numberWithInteger:isLigature] range:range];
//                                                return self;
//                                                }
//                                                
//                                                - (NSMutableAttributedString *)fc_setTextWithObliqueness:(CGFloat)obliqueness inRange:(NSRange)range{
//                                                    
//                                                    [self addAttribute:NSObliquenessAttributeName value:[NSNumber numberWithFloat:obliqueness] range:range];
//                                                    return self;
//                                                    }
//                                                    
//                                                    - (NSMutableAttributedString *)fc_setTextWithBaseLineOffset:(CGFloat)offset inRange:(NSRange)range{
//                                                        
//                                                        [self addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:offset] range:range];
//                                                        return self;
//                                                        }
//                                                        
//                                                        - (NSMutableAttributedString *)fc_setTextWithExpansion:(CGFloat)expansion inRange:(NSRange)range{
//                                                            
//                                                            [self addAttribute:NSExpansionAttributeName value:[NSNumber numberWithFloat:expansion] range:range];
//                                                            return self;
//                                                            }
//                                                            
//                                                            - (NSMutableAttributedString *)fc_setTextWithURL:(NSURL *)url inRange:(NSRange)range{
//                                                                
//                                                                [self addAttribute:NSLinkAttributeName value:url range:range];
//                                                                return self;
//                                                                }
//                                                                
//                                                                - (NSMutableAttributedString *)fc_setTextWithAttacment:(NSTextAttachment *)attachment atIndex:(NSInteger)index{
//                                                                    
//                                                                    NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:attachment];
//                                                                    [self insertAttributedString:str atIndex:index];
//                                                                    return self;
//                                                                    }
//                                                                    
//                                                                    - (NSMutableAttributedString *)fc_setTextWithAttributes:(NSDictionary *)dic inRange:(NSRange)range{
//                                                                        
//                                                                        [self addAttributes:dic range:range];
//                                                                        return self;
//}
//
//
//@end
