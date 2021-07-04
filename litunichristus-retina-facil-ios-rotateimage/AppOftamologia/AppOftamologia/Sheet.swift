//
//  Sheet.swift
//  Brain Anatomy
//
//  Created by Jagni Dasa Horta Bezerra on 05/04/17.
//  Copyright © 2017 Jagni. All rights reserved.
//

import Foundation
import Firebase

class Sheet{ //lâmina
    var name : String = "" //nome da lâmina
    var discription : String = ""
    var image: String = ""
    
    
    init(_ dict: NSDictionary){
        
        self.name = dict.value(forKey: "name") as! String
        self.discription = dict.value(forKey: "description") as! String
        self.image = dict.value(forKey: "image") as! String
    
    }
    
}


extension Array {
    /// Returns an array containing this sequence shuffled
    var shuffled: Array {
        var elements = self
        return elements.shuffle()
    }
    /// Shuffles this sequence in place
    @discardableResult
    mutating func shuffle() -> Array {
        indices.dropLast().forEach {
            guard case let index = Int(arc4random_uniform(UInt32(count - $0))) + $0, index != $0 else { return }
            self.swapAt($0, index)
        }
        return self
    }
    var chooseOne: Element { return self[Int(arc4random_uniform(UInt32(count)))] }
    func choose(_ n: Int) -> Array { return Array(shuffled.prefix(n)) }
}
