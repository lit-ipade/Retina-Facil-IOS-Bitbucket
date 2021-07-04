//
//  User.swift
//  AppOftamologia
//
//  Created by Felipe Martins on 23/11/17.
//  Copyright © 2017 Felipe Martins. All rights reserved.
//

import Foundation
import UIKit

class User {
  
    var patients = [Patient]()
    var name = String()
    var zoomConfiguration = Float(0)
    var matricula = String()
    var uid = String()
    
    init(){
        
        
    }
    
    init(dict: NSDictionary) {
        
        self.name = dict["name"] as! String
        self.matricula = dict["matricula"] as! String
        self.zoomConfiguration = dict["zoomConfiguration"] as? Float ?? 0.0
        if dict.value(forKey: "patients") != nil{
            
            let dictPatients = dict.value(forKey: "patients") as! NSDictionary
            
            for key in dictPatients.allKeys{
                
                patients.append(Patient(dict: dictPatients.value(forKey: key as! String) as! NSDictionary))
                
            }
        }
    }
    
    var asDict : NSMutableDictionary{
        
        return ["patients" : self.patients]
        
    }
}
