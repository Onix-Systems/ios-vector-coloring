//
//  SecondViewController.swift
//  OnixVectorDrawing
//
//  Created by Alexei on 10.05.16.
//  Copyright © 2016 Onix. All rights reserved.
//

import UIKit

struct ONXLayerInfo {
    let x: Float
    let y: Float
    let layer: CAShapeLayer
}

class SecondViewController: UIViewController {
    @IBOutlet weak var drawView: LayerDrawingView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let rootLayer = CALayer()
        if let path = NSBundle.mainBundle().pathForResource("settings", ofType: "json") {
            var json: [String : AnyObject]?
            if let data = NSData(contentsOfFile: path) {
                do {
                    json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String : AnyObject]
                } catch let error as NSError {
                    print(error)
                }
            }
            
            
            if let shapes = json?["shapes"] as? [[String : AnyObject]] {
                for shapeDict in shapes {
                    if let pathsBase64 = shapeDict["encodedShapePaths"] as? String,
                        let xNumber = shapeDict["initialGlobalCartesianPositionX"] as? NSNumber,
                        let yNumber = shapeDict["initialGlobalCartesianPositionY"] as? NSNumber,
                        let scale = shapeDict["localScale"] as? NSNumber {
                        
                        if let pathsData = NSData(base64EncodedString: pathsBase64, options: NSDataBase64DecodingOptions()) {
                            if let pathsObject = NSKeyedUnarchiver.unarchiveObjectWithData(pathsData) {
                                var beziersArray: [UIBezierPath] = []
                                
                                let pathItem = pathsObject.valueForKey("bPath")
                                if let bezier = pathItem as? UIBezierPath {
                                    beziersArray.append(bezier)
                                } else if let array = pathItem as? [UIBezierPath] {
                                    beziersArray.appendContentsOf(array)
                                }
                                
                                if beziersArray.count > 0 {
                                    for bezier in beziersArray {
                                        let layer = CAShapeLayer()
                                        layer.path = bezier.CGPath
                                        layer.position = CGPoint(x: xNumber.doubleValue + 150, y: yNumber.doubleValue + 150)
                                        layer.fillColor = UIColor.blackColor().CGColor
                                        layer.strokeColor = UIColor.blackColor().CGColor
                                        layer.transform = CATransform3DMakeScale(CGFloat(scale.floatValue), CGFloat(scale.floatValue), 1);
                                        rootLayer.addSublayer(layer)
                                    }
                                } else {
                                    print("WRONG path is \(pathsObject.valueForKey("bPath"))")
                                }
                            }
                        }
                    } else {
                        print("YUPIIIII----------------------------\n\(shapeDict)\n----------------------------------")
                    }
                }
            }
        }
        
        self.drawView.drawingLayer = rootLayer
    }
    @IBOutlet weak var imageView: UIImageView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
