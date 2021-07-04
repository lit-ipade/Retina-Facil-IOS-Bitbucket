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

class SingleChildProvider {
    private var path : String = ""
    var update = false
    var parent : FirebaseEntity?
    var entityType = FirebaseEntity.self
    var entityID : String!
    let entity : Variable<FirebaseEntity?>

    init(entityType: FirebaseEntity.Type, parent: FirebaseEntity?, id: String,variable: Variable<FirebaseEntity?>) {
        entity = Variable(FirebaseEntity())
        _ = entity.asObservable().bind(to: variable)
        self.entityType = entityType
        self.parent = parent
        self.path = parent?.path ?? ""
        self.entityID = id
        self.path = path.appending("/\(entityID!)")
        startListeners()
    }

    init(entityType: FirebaseEntity.Type, parentPath: String?, id: String,variable: Variable<FirebaseEntity?>) {
        entity = Variable(FirebaseEntity())
        _ = entity.asObservable().bind(to: variable)
        self.entityType = entityType
        self.path = parentPath ?? ""
        self.entityID = id
        self.path = path.appending("/\(entityID!)")
        startListeners()
    }

    deinit {
        self.clearListeners()
    }

    func startListeners() {

        getUpdatedValue()

        firebaseRef!.child(path).observe(DataEventType.childAdded) { (snap : DataSnapshot) in
            self.getUpdatedValue()
        }

        firebaseRef!.child(path).observe(DataEventType.childChanged) { (snap : DataSnapshot) in
            self.getUpdatedValue()
        }

        firebaseRef!.child(path).observe(DataEventType.childRemoved) { (snap : DataSnapshot) in
            self.getUpdatedValue()
    }
    }

    func getUpdatedValue(){
        firebaseRef!.child(path).observeSingleEvent(of: DataEventType.value) { (snap : DataSnapshot) in
            let dic = snap.value as? [String : Any]
            if let dictionary = dic {
                self.entity.value = self.entityType.init(dict: dictionary, uid: snap.key, parent: self.parent)
                _ = self.entity.asObservable().publish()
            } else {
                self.entity.value = nil
            }
        }
    }

    func clearListeners() {
        firebaseRef!.child(path).removeAllObservers()
    }
}

