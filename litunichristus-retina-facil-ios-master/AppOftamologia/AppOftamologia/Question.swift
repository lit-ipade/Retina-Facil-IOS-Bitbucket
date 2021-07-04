//
//  Question.swift
//  AppOftamologia
//
//  Created by Jagni Dasa Horta Bezerra on 08/02/2018.
//  Copyright © 2018 Felipe Martins. All rights reserved.
//

import Foundation

class Question  {
    var title : String = ""
    var options : [String : String] = [String : String]()
    var correctKey : String = ""
    var answeredKey : String?
    var image : UIImage?
    var comment : String = ""
    
    
    init(dict: NSDictionary) {
        
        self.title = dict["title"] as! String
        self.options = dict["options"] as! [String : String]
        self.comment = dict["comment"] as! String
        
        let imageString = dict["image"] as? String ?? ""
//        if imageString != "" {
//            let dataOptional = Data(base64Encoded: imageString)
//            self.image = UIImage(data: dataOptional!)
//        }
        self.image = UIImage(named: imageString)!
        self.correctKey = dict["correct_key"] as! String
        
        
        
    }
    
    func asDict() -> NSDictionary {
        
        let dict = ["title" : self.title, "comment":self.comment, "options": self.options as NSDictionary, "correct_key" : self.correctKey] as NSMutableDictionary
        
        if image != nil {
            let base64 = UIImageJPEGRepresentation(self.image!, 0.7)?.base64EncodedString()
            dict["image"] = base64
        }
        
        if let answer = self.answeredKey {
            dict["answered_key"] = answer
        }
        
        return dict
    }
}
