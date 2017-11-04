//
//  UIImageExtension.swift
//  PediAR
//
//  Created by 宋 奎熹 on 2017/11/4.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit

extension UIImage {
    
    func getSubImage(rect: CGRect, scale: CGFloat) -> UIImage? {
        if let cgImage = self.cgImage?.cropping(to: CGRect(x: rect.origin.x * scale,
                                                           y: rect.origin.y * scale,
                                                           width: rect.size.width * scale,
                                                           height: rect.size.height * scale)) {
            return UIImage(cgImage: cgImage)
        } else {
            return nil
        }
    }
    
}
