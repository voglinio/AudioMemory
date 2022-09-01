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

let RotateAxisY : Int = 3


class MotionHandler{
    var currDx: Double = 0.0
    var prevDx: Double = 0.0
    var prevPrevDx: Double = 0.0

    var currDy: Double = 0.0
    var prevDy: Double = 0.0
    var prevPrevDy: Double = 0.0

    var currDz: Double = 0.0
    var prevDz: Double = 0.0
    var prevPrevDz: Double = 0.0

    var prevAccel: CMAcceleration = CMAcceleration(x: 0, y: 0, z: 0)
    var prevPrevAccel: CMAcceleration = CMAcceleration(x: 0, y: 0, z: 0)
    var currAccel: CMAcceleration = CMAcceleration(x: 0, y: 0, z: 0)
    
    var currRotDy : Double = 0
    var prevRotDy : Double = 0
    var prevRot: CMRotationRate = CMRotationRate(x: 0, y:0, z:0)
    var currRot: CMRotationRate = CMRotationRate(x: 0, y:0, z:0)


    
    func updateMotion(gyroData: CMGyroData) -> Int {
        currRot = gyroData.rotationRate
        let dy = currRot.y - prevRot.y
        
        currRotDy = dy
        if currRotDy * prevRotDy < 0 && abs(currRotDy) > 4.0 && abs(prevRotDy) > 4.0  {
            print ("y - rotate detected")
            prevRot = currRot
            prevRotDy = currRotDy
            return RotateAxisY
            
        }
        prevRot = currRot
        prevRotDy = currRotDy
        
        return MotionNone
    }
    
    
    func updateMotion(accelerometerData: CMAccelerometerData) -> Int {
        currAccel = accelerometerData.acceleration
        let dx = currAccel.x - prevAccel.x
        let dz = currAccel.z - prevAccel.z

        currDx = dx
        currDz = dz
        
        if currDx * prevDx < 0 && abs(currDx) > 0.6 && abs(prevDx) > 0.6 && abs(prevPrevDx) > 0.6 {
            print ("x - motion detected")
            prevPrevAccel = prevAccel
            prevAccel = currAccel
            
            prevPrevDx = prevDx
            prevPrevDz = prevDz
        
            prevDx = currDx
            prevDz = currDz
            return MotionLeftRight
        }
        
        if currDz * prevDz < 0 && abs(currDz) > 1.0 && abs(prevDz) > 1.0 && abs(prevPrevDz) > 1.0 {
            print ("z - motion detected")
            prevPrevAccel = prevAccel
            prevAccel = currAccel
            
            prevPrevDx = prevDx
            prevPrevDz = prevDz
        
            prevDx = currDx
            prevDz = currDz
            return MotionUpDown
        }
        
        
        prevPrevAccel = prevAccel
        prevAccel = currAccel
        
        prevPrevDx = prevDx
        prevPrevDz = prevDz
    
        prevDx = currDx
        prevDz = currDz

        return MotionNone
    }
    
}
