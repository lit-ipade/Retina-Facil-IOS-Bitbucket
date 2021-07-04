//
//  Extensions.swift
//  GlaucoCheck
//
//  Created by Jagni Dasa Horta Bezerra on 16/08/17.
//  Copyright © 2017 Felipe Martins. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
}

extension NSMutableAttributedString {
    
    func ultraLight(_ text: String) -> NSMutableAttributedString {
        let attrs = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 55, weight: UIFont.Weight.ultraLight)]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    func bold(_ text:String) -> NSMutableAttributedString {
        let attrs = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    func small(_ text:String) -> NSMutableAttributedString {
        let attrs = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    func normal(_ text:String)->NSMutableAttributedString {
        let attrs = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)]
        let normal = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(normal)
        return self
    }
}
