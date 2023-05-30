//
//  Extension+CGFloat.swift
//  ShapeCreatorTest
//
//  Created by user on 29.05.2023.
//

import Foundation

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
}
