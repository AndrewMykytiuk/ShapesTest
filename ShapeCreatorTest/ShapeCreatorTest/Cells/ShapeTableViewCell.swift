//
//  ShapeTableViewCell.swift
//  ShapeCreatorTest
//
//  Created by user on 28.05.2023.
//

import UIKit

final class ShapeTableViewCell: UITableViewCell {
    
    private let shapeNameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        shapeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        shapeNameLabel.font = UIFont(name: "Kefa-Regular", size: 30)
        shapeNameLabel.textColor = .white
        
        contentView.addSubview(shapeNameLabel)
        
        shapeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        shapeNameLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        shapeNameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }
    
    func setUp(with model: ShapeModel) {
        var text = ""
        switch model.shape {
        case .star:
            text = "Star"
        case .square:
            text = "Square"
        case .circle:
            text = "Circle"
        }
        shapeNameLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

