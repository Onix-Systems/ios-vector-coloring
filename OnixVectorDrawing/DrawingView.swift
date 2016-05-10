//
//  DrawingView.swift
//  OnixVectorDrawing
//
//  Created by Alexei on 07.05.16.
//  Copyright © 2016 Onix. All rights reserved.
//

import UIKit

class DrawingView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(DrawingView.pinch))
        self.addGestureRecognizer(pinch)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DrawingView.tap))
        self.addGestureRecognizer(tap)
    }
    
    lazy var aPath: UIBezierPath = {
        let aPath = UIBezierPath()
        
        // Set the starting point of the shape.
        aPath.moveToPoint(CGPointMake(100.0, 0.0))
        
        // Draw the lines.
        aPath.addLineToPoint(CGPointMake(200.0, 40.0))
        aPath.addLineToPoint(CGPointMake(160, 140))
        aPath.addLineToPoint(CGPointMake(40.0, 140))
        aPath.addLineToPoint(CGPointMake(0.0, 40.0))
        aPath.closePath()
        return aPath;
    }()
    
    lazy var arcPath: UIBezierPath = {
        let arcPath = UIBezierPath(arcCenter: CGPointMake(150, 150), radius: 75, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        return arcPath
    }()
    
    var fill1 = false
    var fill2 = false
    
    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        
        CGContextScaleCTM(ctx, scale, scale)
        
        UIColor.greenColor().setFill()
        
        let path = CGPathCreateMutable()
        CGPathAddRect(path, nil, CGRectMake(0,0,200,200))
        CGPathCloseSubpath(path)
        
        CGContextAddPath(ctx, path)
        CGContextFillPath(ctx)
        
        if (fill1) {
            UIColor.blackColor().setFill()
        }
        
        aPath.fill()
        aPath.stroke()
        
        if (fill2) {
            UIColor.blackColor().setFill()
        }
        arcPath.fill()
        arcPath.stroke()
    }
    
    var lastPinchScale: CGFloat = 1.0
    var scale: CGFloat = 1.0
    
    func pinch(sender: UIPinchGestureRecognizer) {
        if (sender.state == .Began) {
            lastPinchScale = 1.0
        }
        
        // Scale
        let scaleDiff = sender.scale - lastPinchScale
        scale += scaleDiff
        lastPinchScale = sender.scale
        
        self.setNeedsDisplay()
        
        // Translate
//        CGPoint point = [sender locationInView:self];
//        [self.layer setAffineTransform:
//            CGAffineTransformTranslate([self.layer affineTransform],
//            point.x - lastPoint.x,
//            point.y - lastPoint.y)];
//        lastPoint = [sender locationInView:self];
    }
    
    func tap(sender: UITapGestureRecognizer) {
        let point = sender.locationInView(self)
//        let convertedPoint = CGPointMake(point.x * scale, point.y * scale)
//        let transform = CGAffineTransformMakeScale(scale, scale)
//        let convertedPoint = CGPointApplyAffineTransform(point, transform)
        
        if (arcPath.containsPoint(point)) {
            fill2 = true
        } else if aPath.containsPoint(point) {
            fill1 = true
        }
        
        self.setNeedsDisplay()
    }
}
