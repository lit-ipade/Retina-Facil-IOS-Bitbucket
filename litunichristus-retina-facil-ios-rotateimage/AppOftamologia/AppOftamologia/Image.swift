//
//  Image.swift
//  GlaucoCheck
//
//  Created by Jagni Dasa Horta Bezerra on 18/08/17.
//  Copyright © 2017 Felipe Martins. All rights reserved.
//

import Foundation

class Image{
    var id : String!
    var base64: String?
    var image: UIImage?
    var date: Date?
    
    init(){}
    
    init (_ dict : NSMutableDictionary, id: String) {
        self.base64 = dict.value(forKey: "foto") as? String
        let dataOptional = Data(base64Encoded: base64!)
        self.image = UIImage(data: dataOptional!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.date = dateFormatter.date(from: dict.value(forKey: "data") as! String)!
        self.id = id
    }
    
    init (_ dict : NSMutableDictionary) {
        self.base64 = dict.value(forKey: "foto") as? String
        let dataOptional = Data(base64Encoded: base64!)
        self.image = UIImage(data: dataOptional!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.date = dateFormatter.date(from: dict.value(forKey: "data") as! String)!
        self.id = "Wololo"
    }
    
    func setDate(withString string: String){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        self.date = dateFormatter.date(from: string)
        
    }
    
    func getDateString() -> String?{
        if self.date != nil{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            return dateFormatter.string(from: self.date!)
        }
        return nil
    }
    
    var asDict : NSMutableDictionary{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: self.date!)
        let base64 = UIImageJPEGRepresentation(self.image!, 0.7)?.base64EncodedString()
        return ["data" : dateString, "foto" : base64]
        
    }

}
