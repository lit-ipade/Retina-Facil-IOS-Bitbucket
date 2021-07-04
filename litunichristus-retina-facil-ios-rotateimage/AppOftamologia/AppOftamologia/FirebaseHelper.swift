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
   
    static func saveUser(_ user : User){
        let userID = Auth.auth().currentUser?.uid
        for key in user.asDict.allKeys{
            firebaseRef!.child("users").child("\(userID)/\(key)").setValue(user.asDict[key])
        }
    }
 
    static func savePatient(_ patient : Patient){
        let userID = Auth.auth().currentUser?.uid as! String
        firebaseRef!.child("users/\(userID)/patients/\(patient.id)").setValue(patient.asDict)
    }
    
    static func deletePatient(_ patient : Patient){
        let userID = Auth.auth().currentUser?.uid as! String
        firebaseRef!.child("users").child("\(userID)/patients/\(patient.id)").removeValue()
    }
    
    static func saveImage(_ image : Image, patientId: String){
        let userID = Auth.auth().currentUser!.uid as! String
        
        if image.id == nil{
            let imageID = firebaseRef!.child("users/\(userID)/patients/\(patientId)/galeria").childByAutoId().key
            image.id = imageID
            print("id: \(imageID)")
            firebaseRef!.child("users/\(userID)/patients/\(patientId)/galeria/\(image.id!)").setValue(image.asDict)
        }
    }

    static func deleteImage(_ image : Image, patientId: String){
        let userID = Auth.auth().currentUser!.uid as! String

        firebaseRef!.child("users/\(userID)/patients/\(patientId)/galeria/\(image.id!)").removeValue()
    }
    /*
    static func saveQuiz(_ quiz : Quiz){
        let userID = FIRAuth.auth()?.currentUser?.uid
        firebaseRef!.child("users").child(userID!).setValue(quiz.asDict)
    }
    
    static func saveQuizTeste(_ quiz : Quiz){
        //let userID = FIRAuth.auth()?.currentUser?.uid
        firebaseRef!.child("users").childByAutoId().setValue(quiz.asDictTeste)
    }

   
 
        firebaseRef!.child("usuarios").child("\(userID)/patients/patientId/galeria").childByAutoId().setValue(image.asDict)
        //firebaseRef!.child("usuarios").child("\(userID)/pacientes/galeria/)\(exam)/\(eye)/\(image.id!)").setValue(image.asDict)
    }
    */

    
}
