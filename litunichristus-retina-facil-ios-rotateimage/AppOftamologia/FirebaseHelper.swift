//
//  FirebaseHelper.swift
//  Quiz
//
//  Created by Jagni Dasa Horta Bezerra on 26/01/17.
//  Copyright © 2017 Jagni Dasa Horta Bezerra. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseHelper{
    
    //MARK: Treatment
    static func saveTreatment(_ treatment : Tratamento){
        let userID = Auth.auth().currentUser!.uid
        
        if treatment.id == nil{
            let treatmentID = firebaseRef!.child("usuarios").child("\(userID)/tratamento").childByAutoId().key
            treatment.id = treatmentID
        }
        
        firebaseRef!.child("usuarios").child("\(userID)/tratamento/\(treatment.id!)").setValue(treatment.asDict)
    }
    
    static func deleteTreatment(_ treatment : Tratamento){
        let userID = Auth.auth().currentUser!.uid
        firebaseRef!.child("usuarios").child("\(userID)/tratamento/\(treatment.id!)").removeValue()
    }
    
    
    //MARK: - Image
    static func saveImage(_ image : Image, eye : String, exam: String){
        let userID = Auth.auth().currentUser!.uid
        
        if image.id == nil{
            let treatmentID = firebaseRef!.child("usuarios").child("\(userID)/exames/galeria/\(exam)/\(eye)").childByAutoId().key
            image.id = treatmentID
        }
        
        firebaseRef!.child("usuarios").child("\(userID)/exames/galeria/\(exam)/\(eye)/\(image.id!)").setValue(image.asDict)
    }
    
    static func deleteImage(_ image : Image, eye : String, exam: String){
        let userID = Auth.auth().currentUser!.uid
        firebaseRef!.child("usuarios").child("\(userID)/exames/galeria/\(exam)/\(eye)/\(image.id!)").removeValue()
    }
    
    
    //MARK: - Pressure
    static func savePressure(_ pressure : Pressao){
        let userID = Auth.auth().currentUser!.uid

        firebaseRef!.child("usuarios").child("\(userID)/pressao/\(pressure.id!)").setValue(pressure.asDict)
    }
    
    static func checkIfPressureExists(_ pressure : Pressao, completion: @escaping (Bool)->Void){
    
        let userID = Auth.auth().currentUser!.uid
        firebaseRef!.child("usuarios").child("\(userID)/pressao/\(pressure.id!)").observeSingleEvent(of: .value, with: { (snap) in
            completion(snap.exists())
        })
        
    }
    
    static func deletePressure(_ pressure : Pressao){
        let userID = Auth.auth().currentUser!.uid
        firebaseRef!.child("usuarios").child("\(userID)/pressao/\(pressure.id!)").removeValue()
    }
    
    
    //MARK: - Alarm
    static func saveAlarm(_ alarm : Alarm){
        let userID = Auth.auth().currentUser!.uid
        firebaseRef!.child("usuarios").child("\(userID)/alarme_colirio/\(alarm.id)").setValue(alarm.asDict)
    }
    
    static func checkIfAlarmExists(_ alarm : Alarm, completion: @escaping (Bool)->Void){
        
        let userID = Auth.auth().currentUser!.uid
        firebaseRef!.child("usuarios").child("\(userID)/alarme_colirio/\(alarm.id)").observeSingleEvent(of: .value, with: { (snap) in
            completion(snap.exists())
        })
        
    }
    
    static func checkIfAlarmExists(_ alarm : String, completion: @escaping (Bool)->Void){
        
        let userID = Auth.auth().currentUser!.uid
        firebaseRef!.child("usuarios").child("\(userID)/alarme_colirio/\(alarm)").observeSingleEvent(of: .value, with: { (snap) in
            completion(snap.exists())
        })
        
    }
    
    static func deleteAlarm(_ alarm : Alarm){
        let userID = Auth.auth().currentUser!.uid
        firebaseRef!.child("usuarios").child("\(userID)/alarme_colirio/\(alarm.id)").removeValue()
    }
    
}
