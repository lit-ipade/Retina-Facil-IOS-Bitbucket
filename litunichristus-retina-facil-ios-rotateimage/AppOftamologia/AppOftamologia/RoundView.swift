//
//  CircleView.swift
//  Quiz
//
//  Created by Jagni Dasa Horta Bezerra on 15/12/17.
//  Copyright © 2017 Unichristus. All rights reserved.
//

import Foundation

extension UINavigationController {
    func fadeTo(_ viewController: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
}

@IBDesignable public class RoundButton: UIButton {
    var ratio : CGFloat = 0
    @IBInspectable var cornerRatio: CGFloat {
        get {
            return ratio
        }
        set {
            ratio = newValue
            self.layer.cornerRadius = newValue * bounds.size.width
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size.width <= bounds.size.height{
            layer.cornerRadius = ratio * bounds.size.width
        } else {
            layer.cornerRadius = ratio * bounds.size.height
        }
    }
}

@IBDesignable public class RoundView: UIView {
    var ratio : CGFloat = 0
    @IBInspectable var cornerRatio: CGFloat {
        get {
            return ratio
        }
        set {
            ratio = newValue
            self.layer.cornerRadius = newValue * bounds.size.width
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = ratio * bounds.size.width
        //clipsToBounds = true
    }
}

@IBDesignable public class ImageRoundView: UIImageView {
    var ratio : CGFloat = 0
    @IBInspectable var cornerRatio: CGFloat {
        get {
            return ratio
        }
        set {
            ratio = newValue
            self.layer.cornerRadius = newValue * bounds.size.width
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = ratio * bounds.size.width
        //clipsToBounds = true
    }
}


