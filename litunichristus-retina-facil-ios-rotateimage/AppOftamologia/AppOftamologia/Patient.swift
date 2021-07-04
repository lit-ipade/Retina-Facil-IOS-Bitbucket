//
//  Patient.swift
//  AppOftamologia
//
//  Created by Felipe Martins on 23/11/17.
//  Copyright © 2017 Felipe Martins. All rights reserved.
//

import Foundation
import UIKit

class Patient {
    
     var name = ""
     
     var galeria = [Image]()
    
     var id = ""
     
     init(){
     }
    
    init(name: String){
        self.name = name
    }
    
     init(dict: NSDictionary) {
     
        self.name = dict.value(forKey: "name") as! String
     
        if dict.value(forKey: "galeria") != nil{
     
            let dictGaleria = dict.value(forKey: "galeria") as! NSDictionary
     
            for key in dictGaleria.allKeys{
     
                //galeria.append(Image(dictGaleria.value(forKey: key as! String) as! NSMutableDictionary))
                //images.append(Answer(dict: dictAnswers.value(forKey: key as! String) as! NSDictionary, id: key as! String))
     
            }
        }
        
        self.id = dict.value(forKey: "id") as! String
     
    
     }
     
     var asDict : NSMutableDictionary{
     
        
        
        return ["name" : self.name,  "id" : self.id]
     
     }
}
