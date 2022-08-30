//
//  MotionHandler.swift
//  Memory
//
//  Created by Konstantinos Vogklis on 30/8/22.
//  Copyright © 2022 Xiomara. All rights reserved.
//

import Foundation
import CoreMotion

let MotionNone: Int = 0
let MotionUpDown: Int = 1
let MotionLeftRight: Int = 2


class MotionHandler{
    var currDx: Double = 0.0
    var prevDx: Double = 0.0
    var currDy: Double = 0.0
    var prevDy: Double = 0.0
    var currDz: Double = 0.0
    var prevDz: Double = 0.0
    var prevAccel: CMAcceleration = CMAcceleration(x: 0, y: 0, z: 0)
    var currAccel: CMAcceleration = CMAcceleration(x: 0, y: 0, z: 0)

    
    
    func updateMotion(accelerometerData: CMAccelerometerData) -> Int {
        currAccel = accelerometerData.acceleration
        let dx = currAccel.x - prevAccel.x
        let dz = currAccel.z - prevAccel.z

        currDx = dx
        currDz = dz

        
        if currDx * prevDx < 0 && abs(currDx) > 0.7 && abs(prevDx) > 0.7 {
            print ("x - motion detected")
            prevAccel = currAccel
            prevDx = currDx

            return MotionLeftRight
        }
        
        if currDz * prevDz < 0 && abs(currDz) > 0.7 && abs(prevDz) > 0.7 {
            print ("z- motion detected")
            prevAccel = currAccel
            prevDz = currDz

            return MotionUpDown
        }
        
        
        prevAccel = currAccel
        prevDx = currDx
        prevDz = currDz

        return MotionNone
    }
    
}
