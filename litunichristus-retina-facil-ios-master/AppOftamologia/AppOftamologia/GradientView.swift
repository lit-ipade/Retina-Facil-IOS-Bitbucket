//
//  GradientView.swift
//  ArtroplastiaJoelho
//
//  Created by Jagni Dasa Horta Bezerra on 01/11/16.
//  Copyright © 2016 WhitneyLand. All rights reserved.
//
import Foundation
import UIKit

@IBDesignable class GradientView: UIView {
    
    //Propriedades ajustáveis via Storyboard
    @IBInspectable var startColor: UIColor = UIColor.red
    @IBInspectable var endColor: UIColor = UIColor.green
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.cgColor, endColor.cgColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x:0, y:self.bounds.height)
        context?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions.drawsAfterEndLocation)
    }
}
