//
//  PredictedPoint.swift
//  PoseDetectionProto
//
//  Created by 정은서 on 2021/11/24.
//

import Foundation
import CoreGraphics

struct PredictedPoint {
    let maxPoint: CGPoint
    let maxConfidence: Double
    
    init(maxPoint: CGPoint, maxConfidence: Double) {
        self.maxPoint = maxPoint
        self.maxConfidence = maxConfidence
    }
    
    init(capturePoint: CapturedPoint){
        self.maxPoint = capturePoint.point
        self.maxConfidence = 1
    }
}

class CapturedPoint: NSObject, NSCoding {
    let point: CGPoint
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(point, forKey: "point")
    }
    
    required init?(coder aDecoder: NSCoder) {
        point = aDecoder.decodeObject(forKey: "point") as? CGPoint ?? aDecoder.decodeCGPoint(forKey: "point")
    }
    
    init(predictedPoint: PredictedPoint){
        point = predictedPoint.maxPoint
    }
}

struct CapturedPointAngle {
    static let angleIndicesArray = [
        (8, 6, 5),
        (7, 5, 6),
        (5, 7, 9),
        (10, 8, 6),
        (8, 6, 12),
        (7, 5, 11),
        (6, 12, 14),
        (5, 11, 13),
        (12, 14, 16),
        (11, 13, 15),
    ]
}

struct CapturedPointVector {
    static let vectorIndicesArray = [
        (8, 6),
        (6, 5),
        (7, 5),
        (7, 9),
        (10, 8),
        (6, 12),
        (5, 11),
        (12, 14),
        (11, 13),
        (14, 16),
        (13, 15),
    ]
}

extension Array where Element == CapturedPoint? {
    func matchVector(with predictedPoints: [PredictedPoint?]) -> CGFloat {
        guard predictedPoints.count >= 18, self.count >= 18 else {
            return -100000
        }
        
        var numberOfValidCapturedPointAngle = 0
        var totalAngleLoss: CGFloat = 0
        
        for (index1, index2) in CapturedPointVector.vectorIndicesArray {
            guard let p1_1 = self[index1]?.point,
                  let p1_2 = self[index2]?.point,
                  let p2_1 = predictedPoints[index1]?.maxPoint,
                  let p2_2 = predictedPoints[index2]?.maxPoint else {
                      continue
            }
            
            let vec1 = p1_2 - p1_1
            let vec2 = p2_2 - p2_1
            let angleLoss = CGPoint.zero.angle(with: vec1, and: vec2)
            
            totalAngleLoss += angleLoss
            numberOfValidCapturedPointAngle += 1
                  
        }
        
        if numberOfValidCapturedPointAngle == 0 {
            return 0
        }else{
            var ratio = (totalAngleLoss / CGFloat(numberOfValidCapturedPointAngle)) / ((CGFloat.pi)/2)
            if ratio < 0 {ratio = 0}
            else if ratio > 1 {ratio = 1}
            return 1 - ratio
        }
    }
    
    func matchAngle(with predictedPoints: [PredictedPoint?]) -> CGFloat {
        guard predictedPoints.count >= 18, self.count >= 18 else {
            print("guard: ",-100000)
            return -100000
        }
        
        var numberOfValidCapturedPointAngle = 0
        var totalAngleLoss: CGFloat = 0
        
        for(index1, index2, index3) in CapturedPointAngle.angleIndicesArray{
            guard let p1 = self[index1]?.point,
                  let center = self[index2]?.point,
                  let p2 = self[index3]?.point else {
                      continue
            }
            
            numberOfValidCapturedPointAngle += 1
            
            let angle = center.angle(with: p1, and: p2)
            var targetAngle: CGFloat? = nil
            if let p1 = predictedPoints[index1]?.maxPoint,
               let center = predictedPoints[index2]?.maxPoint,
               let p2 = predictedPoints[index3]?.maxPoint {
                targetAngle = center.angle(with: p1, and: p2)
            }
            
            var angleLoss = CGFloat.pi
            if let targetAngle = targetAngle {
                angleLoss = abs(targetAngle - angle)
            }
            
            totalAngleLoss += angleLoss
        }
        
        if numberOfValidCapturedPointAngle == 0 {
            return 0
        }else{
            return 1 - (totalAngleLoss / CGFloat(numberOfValidCapturedPointAngle)) / CGFloat.pi
        }
    }
}

extension CGPoint {
    func angle(with p1: CGPoint, and p2: CGPoint) -> CGFloat {
        let center = self
        let transformedP1 = CGPoint(x: p1.x - center.x, y: p1.y - center.y)
        let transformedP2 = CGPoint(x: p2.x - center.x, y: p2.y - center.y)
        
        let angleToP1 = atan2(transformedP1.y, transformedP1.x)
        let angleToP2 = atan2(transformedP2.y, transformedP2.x)
        
        return normalizeToInteriorAngle(with: angleToP2 - angleToP1)
    }
    
    func normalizeToInteriorAngle(with angle: CGFloat) -> CGFloat {
        var angle = angle
        if (angle < 0) {
            angle += (2*CGFloat.pi)
        }
        if(angle > CGFloat.pi) {
            angle = 2*CGFloat.pi - angle
        }
        return angle
    }
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
