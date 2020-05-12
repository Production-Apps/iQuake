//
//  GraphView.swift
//  Quakes
//
//  Created by FGT MAC on 5/10/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    private let borderColor = UIColor.red
    private let borderBgColor = UIColor.gray
    private let centerColor = UIColor.clear
    
    private let borderWidth: CGFloat = 10.0
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
         //Drawing code
        if let context = UIGraphicsGetCurrentContext() {

            // Center
            context.addEllipse(in: rect)
            context.setFillColor(centerColor.cgColor)
            context.fillPath()

            // Border
            context.addEllipse(in: CGRect(
                x: rect.origin.x + borderWidth / 2.0,
                y: rect.origin.y + borderWidth / 2.0,
                width: rect.size.width - borderWidth,
                height: rect.size.height - borderWidth
            ))

            context.setStrokeColor(borderBgColor.cgColor)
            context.setLineWidth(borderWidth)
            context.strokePath()

            // Border
            context.addEllipse(in: CGRect(
                x: rect.origin.x + borderWidth / 2.0,
                y: rect.origin.y + borderWidth / 2.0,
                width: rect.size.width - borderWidth,
                height: rect.size.height - borderWidth
            ))

            context.setStrokeColor(borderColor.cgColor)
            context.setLineWidth(borderWidth)
            context.strokePath()
        }
    }
}
