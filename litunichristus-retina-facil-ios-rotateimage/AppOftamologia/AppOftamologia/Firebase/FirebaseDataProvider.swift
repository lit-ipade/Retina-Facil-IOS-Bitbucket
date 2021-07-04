//
//  ResidentDataProvider.swift
//  surgery-avaliation
//
//  Created by Jagni Dasa Horta Bezerra on 19/10/17.
//  Copyright © 2017 Unichristus. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

class ListDataProvider {
    private var path : String = ""
    var update = false
    var parent : FirebaseEntity?
    var entityType = FirebaseEntity.self
    let entities : Variable<[FirebaseEntity]>

    init(entityType: FirebaseEntity.Type, parent: FirebaseEntity?, variable: Variable<[FirebaseEntity]>) {
        entities = Variable([FirebaseEntity]())
        _ = entities.asObservable().bind(to: variable)
        self.entityType = entityType
        self.parent = parent
        self.path = parent?.path ?? ""
        self.path = path.appending("/\(entityType.pluralName)")
        startListeners()
    }

    deinit {
        self.clearListeners()
    }

    func startListeners() {
        firebaseRef!.child(path).observe(DataEventType.childAdded) { (snap : DataSnapshot) in
            let dic = snap.value as! [String : Any]
            let entity = self.entityType.init(dict: dic, uid: snap.key, parent: self.parent)
            if !self.entities.value.contains(where: { (e) -> Bool in
                entity.uid == e.uid
            }){
            self.entities.value.append(entity)
            }
        }

        firebaseRef!.child(path).observe(DataEventType.childChanged) { (snap : DataSnapshot) in
            let dic = snap.value as! [String : Any]

            let index = self.entities.value.index(where: { (entity) -> Bool in
                entity.uid == snap.key
            })

            self.entities.value[index!] = self.entityType.init(dict: dic, uid: snap.key, parent: self.parent)
            _ = self.entities.asObservable().publish()
        }

        firebaseRef!.child(path).observe(DataEventType.childRemoved) { (snap : DataSnapshot) in
            let index = self.entities.value.index(where: { (entity) -> Bool in
                entity.uid == snap.key
            })
            self.entities.value.remove(at: index!)
        }
    }

    func clearListeners() {
        firebaseRef!.child(path).removeAllObservers()
    }
}
