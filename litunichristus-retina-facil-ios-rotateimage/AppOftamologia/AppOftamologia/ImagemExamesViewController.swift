//
//  ImagemExamesViewController.swift
//  GlaucoCheck
//
//  Created by Felipe Martins on 14/03/17.
//  Copyright © 2017 Felipe Martins. All rights reserved.
//

import UIKit

class ImagemExamesViewController: UIViewController, UIScrollViewDelegate {
    
    var image : UIImage!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = image
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView.superview
    }
}
