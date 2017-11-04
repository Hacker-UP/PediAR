//
//  SCNVector3Extension.swift
//  PediAR
//
//  Created by 宋 奎熹 on 2017/11/4.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import Foundation
import SceneKit

extension SCNVector3 {
    
    func distance(from anotherVector: SCNVector3) -> Float {
        return ((self.x - anotherVector.x).sqaured
            + (self.y - anotherVector.y).sqaured
            + (self.z - anotherVector.z).sqaured).squareRoot()
    }
    
}
