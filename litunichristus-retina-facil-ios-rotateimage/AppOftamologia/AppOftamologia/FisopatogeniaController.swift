//
//  FisopatogeniaController.swift
//  AppOftamologia
//
//  Created by Laboratorio de Inovações Tecnologicas on 09/04/2018.
//  Copyright © 2018 Felipe Martins. All rights reserved.
//

import Foundation

class FisiopatogeniaController : UITableView, UIScrollViewDelegate{
    
    @IBOutlet var imageView: UIImageView!
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
