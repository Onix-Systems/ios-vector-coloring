//
//  LayerDrawingView.swift
//  OnixVectorDrawing
//
//  Created by Alexei on 11.05.16.
//  Copyright © 2016 Onix. All rights reserved.
//

import UIKit

class LayerDrawingView: UIView {
    var drawingLayer: CALayer? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if let layer = drawingLayer, let context = UIGraphicsGetCurrentContext() {
            layer.renderInContext(context)
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
}
