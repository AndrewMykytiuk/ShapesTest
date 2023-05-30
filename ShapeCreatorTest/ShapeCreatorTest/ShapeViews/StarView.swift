//
//  StarView.swift
//  ShapeCreatorTest
//
//  Created by user on 28.05.2023.
//

import UIKit

final class StarView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createStar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createStar()
    }
    
    private func createStar() {
        let shapeLayer = CAShapeLayer()
        
        let dashPattern: [NSNumber] = [5, 4, 3, 2]

        shapeLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width - 2, height: self.frame.width - 2)
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineWidth = 10.0
        shapeLayer.miterLimit = 2.0
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.systemPink.cgColor
        shapeLayer.lineDashPattern = dashPattern

        let starPath = UIBezierPath()

        let center = shapeLayer.position

        let numberOfPoints = CGFloat(5.0)
        let numberOfLineSegments = Int(numberOfPoints * 2.0)
        let theta = .pi / numberOfPoints

        let circumscribedRadius = center.x
        let outerRadius = circumscribedRadius * 1.039
        let excessRadius = outerRadius - circumscribedRadius
        let innerRadius = CGFloat(outerRadius * 0.382)

        let leftEdgePointX = (center.x + cos(4.0 * theta) * outerRadius) + excessRadius
        let horizontalOffset = leftEdgePointX / 2.0

        // Apply a slight horizontal offset so the star appears to be more
        // centered visually
        let offsetCenter = CGPoint(x: center.x - horizontalOffset, y: center.y)

        // Alternate between the outer and inner radii while moving evenly along the
        // circumference of the circle, connecting each point with a line segment
        for i in 0..<numberOfLineSegments {
            let radius = i % 2 == 0 ? outerRadius : innerRadius

            let pointX = offsetCenter.x + cos(CGFloat(i) * theta) * radius
            let pointY = offsetCenter.y + sin(CGFloat(i) * theta) * radius
            let point = CGPoint(x: pointX, y: pointY)

            if i == 0 {
                starPath.move(to: point)
            } else {
                starPath.addLine(to: point)
            }
        }

        starPath.close()

        // Rotate the path so the star points up as expected
        var pathTransform  = CGAffineTransform.identity
        pathTransform = pathTransform.translatedBy(x: center.x, y: center.y)
        pathTransform = pathTransform.rotated(by: CGFloat(-.pi / 2.0))
        pathTransform = pathTransform.translatedBy(x: -center.x, y: -center.y)

        starPath.apply(pathTransform)
        
        shapeLayer.path = starPath.cgPath
        
        self.addAnimation(to: shapeLayer)
        self.layer.addSublayer(shapeLayer)
    }
    
    private func addAnimation(to layer: CALayer) {
        let dashPattern: [NSNumber] = [5, 4, 3, 2]
        let dashPhase = dashPattern.map( { return Float(truncating: $0) } ).reduce(0, { $0 + $1 })
        
        let lineDashPhaseAnimation = CABasicAnimation(keyPath: "lineDashPhase")
        lineDashPhaseAnimation.byValue = dashPhase
        lineDashPhaseAnimation.duration = 0.75
        lineDashPhaseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        lineDashPhaseAnimation.repeatCount = .greatestFiniteMagnitude

        layer.add(lineDashPhaseAnimation, forKey: "lineDashPhaseAnimation")
    }
}
