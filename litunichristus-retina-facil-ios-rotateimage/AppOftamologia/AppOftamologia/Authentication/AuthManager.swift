//
//  UserManager.swift
//  surgery-avaliation
//
//  Created by Jagni Dasa Horta Bezerra on 19/10/17.
//  Copyright © 2017 Unichristus. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import RxSwift

class AuthManager {

    static func newInstallation() -> Bool {
        let userDefaults = UserDefaults.standard

        if userDefaults.bool(forKey: "hasRunBefore") == false {
            do {
                try Auth.auth().signOut()
            } catch {
                print("Signout error")
            }

            userDefaults.set(true, forKey: "hasRunBefore")
            userDefaults.synchronize()
            return true
        } else {
            return false
        }
    }
    
    static func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Signout error")
        }
    }

    static func checkIfNeedsLogin(completion: @escaping (Bool) -> Void) {

        if newInstallation() {
            logout()
            completion(true)
        } else if let uid = Auth.auth().currentUser?.uid {
            completion(false)
        } else {
            completion(true)
        }
    }

    static func login(withEmail mail: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: mail, password: password) { (user, error) in

            if error == nil {
                completion(true)
            } else {

                var errorString = ""

                let infoDict = error!._userInfo as! NSDictionary

                let errorName = infoDict["error_name"] as! String

                if errorName == "ERROR_WRONG_PASSWORD"{

                    errorString = "Senha incorreta"

                } else if errorName == "ERROR_USER_NOT_FOUND"{
                    errorString = "Verifique se o email está correto"
                } else {
                    errorString = "Verifique sua conexão"
                }

                AlertHelper.showError(message: errorString)
                completion(false)
            }
        }
    }

    static func signup(withEmail mail: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: mail, password: password) { (user, error) in

            if error == nil {
                completion(true)
            } else {
                AlertHelper.showError(message: error!.localizedDescription)
                completion(false)
            }

        }
    }
}
