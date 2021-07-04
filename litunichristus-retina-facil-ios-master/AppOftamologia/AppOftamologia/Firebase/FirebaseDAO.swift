//
//  FirebaseHelper.swift
//  surgery-avaliation
//
//  Created by Jagni Dasa Horta Bezerra on 20/10/17.
//  Copyright © 2017 Unichristus. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

var firebaseRef : DatabaseReference?

class FirebaseDAO {

    static func configure() {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        firebaseRef = Database.database().reference()
    }

    static func create(entity: FirebaseEntity) {
        var parentPath = entity.parentPath ?? ""

        if parentPath == "" { parentPath = type(of: entity).pluralName }

        if entity.uid == ""{
                let newID = firebaseRef!.child(parentPath).childByAutoId().key
                entity.uid = newID
        }

        if let path = entity.path {
            firebaseRef!.child(path).setValue(entity.asDict())
        }
    }

    static func update(entity: FirebaseEntity) {
        if let path = entity.path {
            let dict = entity.asDict()
            for key in dict.allKeys {
                firebaseRef!.child(path).child(key as! String).setValue(dict[key])
            }
        }
    }

    static func delete(entity: FirebaseEntity) {
        if let path = entity.path {
            firebaseRef?.child(path).removeValue()
        }
    }

    static func getList(entity: FirebaseEntity.Type,parent: FirebaseEntity?, completion: @escaping ([FirebaseEntity]) -> (Void)){
        var resultList = [FirebaseEntity]()
        var path = parent?.path ?? ""
        path = path.appending("/\(entity.pluralName)")
        firebaseRef!.child(path).observeSingleEvent(of: DataEventType.value, with: { (snap) in
            let dic = snap.value as? [[String : Any]]
            if snap.exists() && dic != nil {
                for i in 0...dic!.count-1 {
                    let entity = entity.init(dict: dic![i], uid: "\(i)", parent: parent)
                    resultList.append(entity)
                }
            }
            completion(resultList)
        })
    }

    static func getEntityByPath<E : FirebaseEntity>(entity: E.Type, path: String, completion: @escaping (E?) -> (Void)){
        firebaseRef!.child(path).observeSingleEvent(of: DataEventType.value, with: { (snap) in
            let dic = snap.value as? [String : Any]
            if let dict = dic {
                completion(entity.init(dict: dict, uid: snap.key, parent: nil))
            } else {
                completion(nil)
            }
        })
    }

}
