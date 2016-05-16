//
//  LayerDrawingView.swift
//  OnixVectorDrawing
//
//  Created by Alexei on 11.05.16.
//  Copyright © 2016 Onix. All rights reserved.
//

import UIKit

class LayerDrawingView: UIView, UIScrollViewDelegate {
    var drawingLayer: CALayer? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private var fillColor = UIColor.redColor()
    func setFillColor(color: UIColor) {
        fillColor = color
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.whiteColor()
        self.clearsContextBeforeDrawing = true
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture))
        self.addGestureRecognizer(pinch)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        pan.minimumNumberOfTouches = 2
        self.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        tap.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tap)
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if let layer = drawingLayer, let context = UIGraphicsGetCurrentContext() {
            CGContextScaleCTM(context, scaleForCTM, scaleForCTM)
            CGContextTranslateCTM(context, translateForCTM.x, translateForCTM.y)
            
            layer.renderInContext(context)
        }
    }
    
    var lastPinchScale: CGFloat = 1.0
    private var scaleForCTM: CGFloat = 1.0
    
    private var lastPanTranslate = CGPointZero
    private var translateForCTM = CGPointZero
    
    func pinchGesture(sender: UIPinchGestureRecognizer) {
        if (sender.state == .Began) {
            lastPinchScale = 1.0
        }
        
        // Scale
        let scaleDiff = sender.scale - lastPinchScale
        scaleForCTM += (scaleDiff * scaleForCTM)
        lastPinchScale = sender.scale
        
        self.setNeedsDisplay()
    }
    
    func panGesture(sender: UIPanGestureRecognizer) {
        if (sender.state == .Began) {
            lastPanTranslate = CGPointZero
        }
        
        let translation = sender.translationInView(self)
        let translateDiff = CGPointMake(translation.x - lastPanTranslate.x, translation.y - lastPanTranslate.y)
        translateForCTM = CGPointMake(translateForCTM.x + (translateDiff.x / scaleForCTM), translateForCTM.y + (translateDiff.y / scaleForCTM))
        lastPanTranslate = translation
        
        self.setNeedsDisplay()
    }
    
    func tapGesture(sender: UITapGestureRecognizer) {
        let point = sender.locationInView(self)
        let scaleTransform = CGAffineTransformMakeScale(1 / scaleForCTM, 1 / scaleForCTM)
        let scaledPoint = CGPointApplyAffineTransform(point, scaleTransform)
        let translateTransform = CGAffineTransformMakeTranslation(-translateForCTM.x, -translateForCTM.y)
        let translatedPoint = CGPointApplyAffineTransform(scaledPoint, translateTransform)
        
        if let layer = self.drawingLayer?.hitTest(translatedPoint) as? CAShapeLayer {
            layer.fillColor = fillColor.CGColor
        }
        
        self.setNeedsDisplay()
    }
}
