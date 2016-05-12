//
//  SecondViewController.swift
//  OnixVectorDrawing
//
//  Created by Alexei on 10.05.16.
//  Copyright © 2016 Onix. All rights reserved.
//

import UIKit
import SVGKit
import NKOColorPickerView

struct ONXLayerInfo {
    let x: Float
    let y: Float
    let layer: CAShapeLayer
}

class SecondViewController: UIViewController {
    @IBOutlet weak var drawView: ContainerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = NKOColorPickerView(frame: CGRectZero, color: self.color ?? UIColor.whiteColor()) { (color) in
            self.color = color
            self.drawView.setFillColor(color)
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        view.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active = true
        view.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor).active = true
        view.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
        view.heightAnchor.constraintEqualToConstant(300).active = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let url = NSBundle.mainBundle().URLForResource("testParser", withExtension: "svg")
        let source = SVGKSourceURL.sourceFromURL(url)
        self.setSVGSource(source)
    }
    @IBOutlet weak var imageView: UIImageView!
    
    func setSVGSource(source: SVGKSource) {
        _ = SVGKImage.imageWithSource(source, onCompletion: { loadedImage, parseResult in
            for layer in loadedImage.CALayerTree.sublayers! {
                if let shapeLayer = layer as? CAShapeLayer {
                    print("\n---------------------\n\(shapeLayer.description)\nPATH\(shapeLayer.path!)\n----------------------")
                }
            }
            
            self.drawView.drawingLayer = loadedImage.CALayerTree
        })
    }
    
    var color: UIColor?
}
