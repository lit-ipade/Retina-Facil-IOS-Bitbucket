//
//  ConceitosController.swift
//  AppOftamologia
//
//  Created by Laboratorio de Inovações Tecnologicas on 22/05/2018.
//  Copyright © 2018 Unichristus. All rights reserved.
//

import Foundation

class ConceitosController: UITableViewController{
    
    var titleName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
             
        if #available(iOS 11.0, *), UIDevice.current.userInterfaceIdiom == .phone{
            navigationItem.largeTitleDisplayMode = .always
            
            self.navigationController?.navigationBar.largeTitleTextAttributes![NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
            
        }
    
    }
}
