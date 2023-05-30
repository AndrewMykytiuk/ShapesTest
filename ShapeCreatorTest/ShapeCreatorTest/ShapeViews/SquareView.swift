//
//  SquareView.swift
//  ShapeCreatorTest
//
//  Created by user on 28.05.2023.
//

import UIKit

final class SquareView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSquare()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createSquare()
    }
    
    private func createSquare() {
        CATransaction.begin()
        let layer : CAShapeLayer = CAShapeLayer()
        layer.strokeColor = UIColor.purple.cgColor
        layer.lineWidth = 3.0
        layer.fillColor = UIColor.clear.cgColor
        //x: self.frame.midX, y: self.frame.midY
        let path : UIBezierPath = UIBezierPath(roundedRect: CGRect(x: self.frame.size.width / 3, y: 50, width: self.frame.size.width / 2, height: self.frame.width / 2), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 5.0, height: 0.0))
        layer.path = path.cgPath
        addAnimation(to: layer)
        CATransaction.commit()
        self.layer.addSublayer(layer)
    }
    
    private func addAnimation(to layer: CALayer) {
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.75
        layer.add(animation, forKey: "myStroke")
    }
}


