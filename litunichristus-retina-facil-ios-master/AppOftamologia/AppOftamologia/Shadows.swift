//
//  Shadows.swift
//  QuizOrtopedia
//
//  Created by Jagni Dasa Horta Bezerra on 07/12/16.
//  Copyright © 2016 Jagni Dasa Horta Bezerra. All rights reserved.
//

import Foundation
import UIKit

public class EdgeShadowLayer: CAGradientLayer {
    
    public enum Edge {
        case Top
        case Left
        case Bottom
        case Right
    }
    
    public init(forView view: UIView,
                edge: Edge = Edge.Top,
                shadowRadius radius: CGFloat = 20.0,
                toColor: UIColor = UIColor.white,
                fromColor: UIColor = UIColor.black, opacity: Float) {
        super.init()
        self.colors = [fromColor.cgColor, toColor.cgColor]
        self.shadowRadius = radius
        self.opacity = opacity
        let viewFrame = view.frame
        
        switch edge {
        case .Top:
            startPoint = CGPoint(x: 0.5, y: 0.0)
            endPoint = CGPoint(x: 0.5, y: 1.0)
            self.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width, height: shadowRadius)
        case .Bottom:
            startPoint = CGPoint(x: 0.5, y: 1.0)
            endPoint = CGPoint(x: 0.5, y: 0.0)
            self.frame = CGRect(x: 0.0, y: viewFrame.height - shadowRadius, width: viewFrame.width, height: shadowRadius)
        case .Left:
            startPoint = CGPoint(x: 0.0, y: 0.5)
            endPoint = CGPoint(x: 1.0, y: 0.5)
            self.frame = CGRect(x: 0.0, y: 0.0, width: shadowRadius, height: viewFrame.height)
        case .Right:
            startPoint = CGPoint(x: 1.0, y: 0.5)
            endPoint = CGPoint(x: 0.0, y: 0.5)
            self.frame = CGRect(x: viewFrame.width - shadowRadius, y: 0.0, width: shadowRadius, height: viewFrame.height)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

func addDefaultInnerShadow(view: UIView){
    let topShadow = EdgeShadowLayer(forView: view, edge: EdgeShadowLayer.Edge.Top, shadowRadius: 5, toColor: lightGrey, fromColor: UIColor.black, opacity: 0.1)
    view.layer.addSublayer(topShadow)
}

func addBottomInnerShadow(view: UIView){
    let topShadow = EdgeShadowLayer(forView: view, edge: EdgeShadowLayer.Edge.Bottom, shadowRadius: 5, toColor: lightGrey, fromColor: UIColor.black, opacity: 0.1)
    view.layer.addSublayer(topShadow)
}
