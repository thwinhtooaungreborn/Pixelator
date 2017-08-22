//
//  Pixelator+UIImage.swift
//  TTMPixelator
//
//  Created by Thwin Htoo Aung on 8/23/17.
//  Copyright © 2017 Thwin Htoo Aung. All rights reserved.
//

import Foundation
import UIKit.UIImage

extension UIImage {
    func pixelated(downRate: Int) -> UIImage! {
        let pixelator = Pixelator()
        pixelator.set(image: self)
        return pixelator.pixelate(downRate: downRate);
    }
}
