//
//  Pixelator.swift
//  TTMPixelator
//
//  Created by Thwin Htoo Aung on 8/23/17.
//  Copyright © 2017 Thwin Htoo Aung. All rights reserved.
//




#if TARGET_OS_IPHONE
    import UIKit;
    typealias CrossImage = UIImage;
#else
    import AppKit
    typealias CrossImage = NSImage;
#endif


class Pixelator: NSObject {
    
    typealias PixMap = RawImage
    
    
    private var original: PixMap?
    private var modified: PixMap?
    
    
    override init() {
        super.init()
    }
    
    
    /// Set image to pixelate later
    ///
    /// - Parameter image: image instance to convert to pixelated image later
    ///
    func set(image: CrossImage) {
        original = PixMap.init(image: image)
        modified = nil
    }
    
    
    /// Copy and convert original imaeg to Pixel Art image according to your given downgrade rate (Hopefully).
    /// Processing on large scale image will result in performance penalty.
    /// 
    /// - parameter downRate: pixel down rate (0 or minus values will result in original image).
    ///
    /// - Returns: Pixelated UIImage instance
    ///
    func pixelate(downRate: Int) -> CrossImage! {
        
        modified = original?.copy()
        
        // if the image is set
        if let modified = self.modified {
            
            
            var x = 0;
            var y = 0;
            
            // perform horizontal sampling
            while(y < modified.height) {
                
                while (x < modified.width) {
                    
                    let color = modified.getColorValueOfPixelAt(x: x, andY: y)
                    
                    var jumper = 0;
                    while(jumper < downRate) {
                        
                        modified.setColorValueOfPixelAtX(x, andY: y, withValue: color)
                        
                        jumper += 1;
                        
                        x += 1;
                        
                        if (x >= modified.width) {
                            break;
                        }
                    }
                    
                    x += 1;
                }
                
                y += 1;
                x = 0;
            }
            
            
            
            x = 0;
            y = 0;
            
            // perform vertical sampling
            while(x < modified.width) {
                
                while(y < modified.height) {
                    
                    let color = modified.getColorValueOfPixelAt(x: x, andY: y)
                    
                    var jumper = 0;
                    while(jumper < downRate) {
                        
                        modified.setColorValueOfPixelAtX(x, andY: y, withValue: color)
                        
                        jumper += 1;
                        
                        y += 1;
                        
                        if (y >= modified.height) {
                            break;
                        }
                    }
                    
                    y += 1;

                }
                x += 1;
                y = 0;
            }
            
        }
        
        let ref = modified;
        modified = nil;
        
        return ref?.image;
    }
}
