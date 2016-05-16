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
    @IBOutlet weak var drawView: LayerDrawingView!
    
    let colorPicker: NKOColorPickerView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        colorPicker = NKOColorPickerView(frame: CGRectZero, color: UIColor.grayColor(), andDidChangeColorBlock: nil)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        colorPicker = NKOColorPickerView(frame: CGRectZero, color: UIColor.grayColor(), andDidChangeColorBlock: nil)
        
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        colorPicker.didChangeColorBlock = { color in
            self.color = color
            self.drawView.setFillColor(color)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .System)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Color picker", forState: .Normal)
        button.addTarget(self, action: #selector(colorPickerButtonAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
        
        button.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -10).active = true
        button.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -10).active = true
        
        colorPicker.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(colorPicker)
        colorPicker.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        colorPicker.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        colorPicker.bottomAnchor.constraintEqualToAnchor(button.topAnchor, constant: 0).active = true
        colorPicker.heightAnchor.constraintEqualToConstant(300).active = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let url = NSBundle.mainBundle().URLForResource("testParser", withExtension: "svg")
        let source = SVGKSourceURL.sourceFromURL(url)
        self.setSVGSource(source)
    }
    @IBOutlet weak var imageView: UIImageView!
    
    func colorPickerButtonAction(sender: UIButton) {
        colorPicker.hidden = !colorPicker.hidden
    }
    
    func setSVGSource(source: SVGKSource) {
        _ = SVGKImage.imageWithSource(source, onCompletion: { loadedImage, parseResult in
            dispatch_async(dispatch_get_main_queue(), {
                self.drawView.drawingLayer = loadedImage.CALayerTree
            })
        })
    }
    
    var color: UIColor?
}
