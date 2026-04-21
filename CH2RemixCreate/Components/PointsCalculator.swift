//
//  PointsCalculator.swift
//  CH2RemixCreate
//
//  Created by Syauqi Auliya M on 21/04/26.
//



import SwiftUI

struct PointsCalculator {
    
    static let points: [[Double]] = [
        [1, 1], // x -10
        [0.5/12, 0.675],
        [1/12, 0.4],
        [2.5/12, 0.525],
        [4/12,0.65],
        [5/12,0.4],
        [6/12, 0.1],
        [7/12, 0.4],
        [8/12, 0.65],
        [9/12, 0.525],
        [10/12, 0.4],
        [1, 0.8], //x - 35
    ]
    
    static func calculateCoordinates(contentWidth: CGFloat, contentHeight: CGFloat) -> [CGPoint] {
        var calculatedPoints: [CGPoint] = []
        
        for index in (0..<points.count) {
            let xFrac = points[index][0]
            let yFrac = points[index][1]
            
            let x: CGFloat
            
            if index == 0 {
                x = -10
            } else if index == points.count - 1 {
                x = contentWidth - 35
            } else {
                x = contentWidth * CGFloat(xFrac)
            }
            
            let y = contentHeight * CGFloat(yFrac)
            
            calculatedPoints.append(CGPoint(x: x, y: y))
        }
        return calculatedPoints
    }
}


