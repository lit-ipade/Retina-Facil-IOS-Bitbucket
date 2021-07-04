//
//  SheetInfoNavigationController.swift
//  AppOftamologia
//
//  Created by Laboratorio de Inovações Tecnologicas on 27/03/2018.
//  Copyright © 2018 Felipe Martins. All rights reserved.
//

import Foundation
import UIKit

class SheetInfoNavigationController : UINavigationController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var nextController : UIViewController!
        
        for index in 0...sheets.count-1 {
            
            if(index == sheetIndex){
                nextController = self.storyboard?.instantiateViewController(withIdentifier: "SheetInfo")
            }
            else{
                self.storyboard?.instantiateViewController(withIdentifier: "SheetInfo")
            }
            
        }
        
        self.navigationController?.show(nextController!, sender: nil)
    }
    
    
}
