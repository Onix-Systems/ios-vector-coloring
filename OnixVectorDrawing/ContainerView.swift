//
//  ContainerView.swift
//  OnixVectorDrawing
//
//  Created by Alexei on 12.05.16.
//  Copyright © 2016 Onix. All rights reserved.
//

import UIKit

class ContainerView: UIView, UIScrollViewDelegate {

    var drawingLayer: CALayer? {
        didSet {
            contentView.drawingLayer = drawingLayer
        }
    }
    
    func setFillColor(color: UIColor) {
        self.contentView.setFillColor(color)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.blackColor()
    }
    
    let contentView = LayerDrawingView(frame: CGRectZero)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        let scrollView = UIScrollView(frame: CGRectZero)
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.delegate = self
//        scrollView.maximumZoomScale = 100.0
//        scrollView.minimumZoomScale = 0.5
//        self.addSubview(scrollView)
//        scrollView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor).active = true
//        scrollView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor).active = true
//        scrollView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
//        scrollView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        
        let v = self
        contentView.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(contentView)
        contentView.leadingAnchor.constraintEqualToAnchor(v.leadingAnchor).active = true
        contentView.trailingAnchor.constraintEqualToAnchor(v.trailingAnchor).active = true
        contentView.topAnchor.constraintEqualToAnchor(v.topAnchor).active = true
        contentView.bottomAnchor.constraintEqualToAnchor(v.bottomAnchor).active = true
//        contentView.widthAnchor.constraintEqualToConstant(300).active = true
//        contentView.heightAnchor.constraintEqualToConstant(300).active = true
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
//    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
//        contentView.setScale(Float(scale))
//    }
}
