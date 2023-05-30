//
//  CircleView.swift
//  ShapeCreatorTest
//
//  Created by user on 28.05.2023.
//

import UIKit

final class CircleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircle(startAngle: 0, endAngle: 360)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createCircle(startAngle: 0, endAngle: 360)
    }
    
    //return UIBezierPath(arcCenter: CGPoint(x: self.frame.midX, y: self.frame.midY), radius: (self.frame.width / 2.5), startAngle: startAngle.toRadians(), endAngle: endAngle.toRadians(), clockwise: true)
    private func createSegment(startAngle: CGFloat, endAngle: CGFloat) -> UIBezierPath {
        return UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.width / 2), radius: (self.frame.width / 2.5), startAngle: startAngle.toRadians(), endAngle: endAngle.toRadians(), clockwise: true)
    }
    
    private func createCircle(startAngle: CGFloat, endAngle: CGFloat) {
        let segmentPath = createSegment(startAngle: startAngle, endAngle: endAngle)
        let segmentLayer = CAShapeLayer()
        segmentLayer.path = segmentPath.cgPath
        segmentLayer.lineWidth = 25
        segmentLayer.strokeColor = UIColor.blue.cgColor
        segmentLayer.fillColor = UIColor.clear.cgColor
        addAnimation(to: segmentLayer)
        self.layer.addSublayer(segmentLayer)
    }
    
    private func addAnimation(to layer: CALayer) {
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.duration = 0.75
        drawAnimation.repeatCount = 1.0
        drawAnimation.isRemovedOnCompletion = false
        drawAnimation.fromValue = 0
        drawAnimation.toValue = 1
        drawAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        layer.add(drawAnimation, forKey: "drawCircleAnimation")
    }
}
