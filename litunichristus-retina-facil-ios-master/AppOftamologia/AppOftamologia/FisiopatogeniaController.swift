//
//  FisopatogeniaController.swift
//  AppOftamologia
//
//  Created by Laboratorio de Inovações Tecnologicas on 09/04/2018.
//  Copyright © 2018 Felipe Martins. All rights reserved.
//

import Foundation

class FisiopatogeniaController : UITableViewController{
    
    @IBOutlet var imageView: UIImageView!
    
    
    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView != self.tableView {
            return scrollView.subviews[0]
        } else {
            return nil
        }
    }
}
