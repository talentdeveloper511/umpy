/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Defines common types used throughout the sample.
*/

import Foundation
import UIKit
import Vision

struct TrackedObjectsPalette {
    static var RED = UIColor(red: 1, green: 0, blue: 0, alpha: 0.3)
    static var GREEN = UIColor(red: 0, green: 1, blue: 0, alpha: 0.3)
    static var palette = [
        UIColor.green,
        UIColor.cyan,
        UIColor.orange,
        UIColor.brown,
        UIColor.darkGray,
        UIColor.red,
        UIColor.yellow,
        UIColor.magenta,
        #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1), // light green
        UIColor.gray,
        UIColor.purple,
        UIColor.clear,
        #colorLiteral(red: 0, green: 0.9800859094, blue: 0.941437602, alpha: 1),   // light blue
        UIColor.lightGray,
        UIColor.black,
        UIColor.blue
    ]
    
    static func color(atIndex index: Int) -> UIColor {
        if index < palette.count {
            return palette[index]
        }
        return randomColor()
    }
    
    static func randomColor() -> UIColor {
        func randomComponent() -> CGFloat {
            return CGFloat(arc4random_uniform(256)) / 255.0
        }
        return UIColor(red: randomComponent(), green: randomComponent(), blue: randomComponent(), alpha: 1.0)
    }
}

struct TrackedPolyRect {
    var topLeft: CGPoint
    var topRight: CGPoint
    var bottomLeft: CGPoint
    var bottomRight: CGPoint
    
    var cornerPoints: [CGPoint] {
        return [topLeft, topRight, bottomRight, bottomLeft]
    }
    
    var leftSide: [CGPoint] {
        let middleTop = CGPoint(x: topLeft.x + (topRight.x - topLeft.x) / 2 , y: topLeft.y + (topRight.y - topLeft.y) / 2)
        let middleBottom = CGPoint(x: bottomLeft.x + (bottomRight.x - bottomLeft.x) / 2 , y: bottomLeft.y + (topRight.y - bottomLeft.y) / 2)
        return [topLeft, middleTop, middleBottom, bottomLeft]
    }
    
    var rightSide: [CGPoint] {
        let middleTop = CGPoint(x: topLeft.x + (topRight.x - topLeft.x) / 2 , y: topLeft.y + (topRight.y - topLeft.y) / 2)
        let middleBottom = CGPoint(x: bottomLeft.x + (bottomRight.x - bottomLeft.x) / 2 , y: bottomLeft.y + (topRight.y - bottomLeft.y) / 2)
        return [middleTop, topRight, bottomRight, middleBottom]
    }
    
    var boundingBox: CGRect {
        let topLeftRect = CGRect(origin: topLeft, size: .zero)
        let topRightRect = CGRect(origin: topRight, size: .zero)
        let bottomLeftRect = CGRect(origin: bottomLeft, size: .zero)
        let bottomRightRect = CGRect(origin: bottomRight, size: .zero)
        return topLeftRect.union(topRightRect).union(bottomLeftRect).union(bottomRightRect)
    }
    
    init(observation: VNRectangleObservation) {
        topLeft = observation.topLeft
        topRight = observation.topRight
        bottomLeft = observation.bottomLeft
        bottomRight = observation.bottomRight

    }
    
    init(observation: VNDetectedObjectObservation) {
        let bounds = observation.boundingBox
        topLeft = bounds.origin
        topRight = CGPoint(x: bounds.origin.x + bounds.size.width, y: bounds.origin.y)
        bottomLeft = CGPoint(x: bounds.origin.x, y: bounds.origin.y + bounds.size.height)
        bottomRight = CGPoint(x: bounds.origin.x + bounds.size.width, y: bounds.origin.y + bounds.size.height)
    }
    
    init(cgRect: CGRect) {
        topLeft = CGPoint(x: cgRect.minX, y: cgRect.maxY)
        topRight = CGPoint(x: cgRect.maxX, y: cgRect.maxY)
        bottomLeft = CGPoint(x: cgRect.minX, y: cgRect.minY)
        bottomRight = CGPoint(x: cgRect.maxX, y: cgRect.minY)
    }
}

