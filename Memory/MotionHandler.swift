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
    
    var xInPositiveDirection: Double = 0.0
    var xInNegativeDirection: Double = 0.0
    var xShakeCount: Int = 0
    
    var zInPositiveDirection: Double = 0.0
    var zInNegativeDirection: Double = 0.0
    var zShakeCount: Int = 0
    
    var idleCount : Int = 0

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
        
        if currDx * prevDx < 0 && prevPrevDx * prevDx < 0  && abs(currDx) > 0.6 && abs(prevDx) > 0.6 && abs(prevPrevDx) > 0.6 {
            print ("x - motion detected")
            prevPrevAccel = prevAccel
            prevAccel = currAccel
            
            prevPrevDx = prevDx
            prevPrevDz = prevDz
            
            prevDx = currDx
            prevDz = currDz
            return MotionLeftRight
        }
        
        if currDz * prevDz < 0 &&  prevPrevDz * prevDz < 0 && abs(currDz) > 1.0 && abs(prevDz) > 1.0 && abs(prevPrevDz) > 1.0 {
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
    
    
    func updateMotionV2(accelerometerData: CMAccelerometerData) -> Int {
        currAccel = accelerometerData.acceleration
        
        if currAccel.x > 1 || currAccel.x < -1 {
            if currAccel.x > 1 {
                xInPositiveDirection = currAccel.x
            }
            
            if currAccel.x < -1 {
                xInNegativeDirection = currAccel.x
            }
            
            if xInPositiveDirection != 0.0 && xInNegativeDirection != 0.0 {
                xShakeCount = xShakeCount + 1
                xInPositiveDirection = 0.0
                xInNegativeDirection = 0.0
            }
            print ("xShakeCount", xShakeCount)
            
            if xShakeCount >= 2 {
                print ("Shaken x" )
                xShakeCount = 0
                return MotionLeftRight
            }
            return MotionNone
        }
        
        if currAccel.z > 1 || currAccel.z < -1 {
            if currAccel.z > 1 {
                zInPositiveDirection = currAccel.z
            }
            
            if currAccel.z < -1 {
                zInNegativeDirection = currAccel.z
            }
            
            if zInPositiveDirection != 0.0 && zInNegativeDirection != 0.0 {
                zShakeCount = zShakeCount + 1
                zInPositiveDirection = 0.0
                zInNegativeDirection = 0.0
            }
            print ("zShakeCount", zShakeCount)
            
            if zShakeCount >= 2 {
                print ("Shaken z" )
                zShakeCount = 0
                return MotionUpDown
            }
            
            return MotionNone
        }
        
        idleCount = idleCount + 1
        if idleCount > 60   {
            idleCount = 0
            zShakeCount = 0
            xShakeCount = 0
            print ("Reset zShakeCount, xShakeCount")
        }
        
        return MotionNone
    }
    
    
}
