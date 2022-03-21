//
//  RectangleBoxView.swift
//  CodingTaskMobile
//
//  Created by Nikola Andrijasevic on 17.3.22..
//

import UIKit

//@IBDesignable
class RectangleBoxView: UIView {
    
    @IBInspectable var fillColor: UIColor = .black

    private let rectLineWidth: CGFloat = 8.0
    private let halfPointShift: CGFloat = 0.5
    
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: 20.0, height: 20.0))
        path.addClip()
        path.lineWidth = rectLineWidth
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: bounds.width, y: 0))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        path.addLine(to: CGPoint(x: 0, y: bounds.height))
        path.close()
        UIColor.black.setStroke()
        path.stroke()
        
        let apart = UIBezierPath()
        apart.lineWidth = rectLineWidth / 2
        apart.move(to: CGPoint(x: bounds.width / 2 + halfPointShift, y: 0))
        apart.addLine(to: CGPoint(x: bounds.width / 2 + halfPointShift, y: bounds.height))
        apart.stroke()
        
    }
   
    
    
    

}
