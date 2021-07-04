//
//  FirebaseEntity.swift
//  surgery-avaliation
//
//  Created by Jagni Dasa Horta Bezerra on 19/10/17.
//  Copyright © 2017 Unichristus. All rights reserved.
//

import Foundation

protocol Entity {
    init(dict: [String : Any], uid: String, parent: Entity?)

    var uid : String {get set}
    var path: String? {get set}

    func asDict() -> NSDictionary
}

class FirebaseEntity : Entity {

    class var pluralName : String {
        return "firebaseEntities"
    }

    var uid: String = "" {
        didSet {
            path = parentPath
            path?.append("/\(type(of: self).pluralName)/\(uid)")
        }
    }

    var parentPath : String? {
        set {
            self.path = newValue ?? ""
            if uid != ""{
                self.path!.append("/\(type(of: self).pluralName)/\(uid)")
            }
        }
        get {
            return self.path?.replacingOccurrences(of: "/\(type(of: self).pluralName)/\(uid)", with: "")
        }
    }
    
    var path : String? = ""

    required init() {
        self.uid = ""

    }

    required init(dict: [String : Any], uid: String, parent: Entity?) {
        self.uid = uid

        if let p = parent {
            self.parent = p as! FirebaseEntity
        }

        self.path = parent?.path ?? ""
        if uid != ""{
            self.path!.append("/\(type(of: self).pluralName)/\(uid)")
        }
    }

    var parent : FirebaseEntity? = nil {
        didSet{
            self.parentPath = parent?.path
            
        }
    }

    func asDict() -> NSDictionary {
        return [:]
    }
}
