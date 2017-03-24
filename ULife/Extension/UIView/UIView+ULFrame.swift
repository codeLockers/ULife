//
//  UIView+ULFrame.swift
//  ULife
//
//  Created by codeLocker on 2017/3/21.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

extension UIView {
    
    var ul_width : CGFloat {
        
        set{
            self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: newValue, height: self.frame.size.height)
        }
        get{
            return self.frame.size.width
        }
    }
    
    var ul_height : CGFloat {
        
        set{
            self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: newValue)
        }
        get{
            return self.frame.size.height
        }
    }
    
    var ul_minX : CGFloat {
        
        set{
            self.frame = CGRect.init(x: newValue, y: self.frame.origin.y, width: self.ul_width, height: self.ul_height)
        }
        get{
            return self.frame.origin.x
        }
    }
    
    var ul_minY : CGFloat {
        
        set{
            self.frame = CGRect.init(x: self.frame.origin.x, y: newValue, width: self.ul_width, height: self.ul_height)
        }
        get{
            return self.frame.origin.y
        }
    }
    
    var ul_maxX : CGFloat {
        
        set{
            self.frame = CGRect.init(x: newValue - self.ul_width, y: self.ul_minY, width: self.ul_width, height: self.ul_height)
        }
        get{
            return self.ul_minX + self.ul_width
        }
    }
    
    var ul_maxY : CGFloat {
        
        set{
            self.frame = CGRect.init(x: self.ul_minX, y: newValue - self.ul_minY, width: self.ul_width, height: self.ul_height)
        }
        get{
            return self.ul_minY + self.ul_height
        }
    }
    
    var ul_midX : CGFloat {
        
        set{
            self.frame = CGRect.init(x: newValue - self.ul_width/2.0, y: self.ul_minY, width: self.ul_width, height: self.ul_height)
        }
        get{
            return self.center.x
        }
    }
    
    var ul_midY : CGFloat {
        
        set{
            self.frame = CGRect.init(x: self.ul_minX, y: newValue - self.ul_height/2.0, width: self.ul_width, height: self.ul_height)
        }
        get{
            
            return self.center.y
        }
    }
}
