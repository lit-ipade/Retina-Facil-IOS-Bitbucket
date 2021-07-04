//
//  SignupViewModel.swift
//  surgery-avaliation
//
//  Created by Jagni Dasa Horta Bezerra on 19/10/17.
//  Copyright © 2017 Unichristus. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel {
    var authManager = AuthManager()
    let mail = Variable<String>("")
    let password = Variable<String>("")
    let isLoading = Variable<Bool>(false)
    let logged = Variable<Bool>(false)

    let shouldEnableConfirm : Variable<Bool>

    init() {
        shouldEnableConfirm = Variable<Bool>(false)
        _ = Observable.combineLatest(self.mail.asObservable(), self.password.asObservable()) { (email, pass) in
            return !email.isEmpty && !pass.isEmpty
        }.bind(to: shouldEnableConfirm)
    }
    
    func login() {
        isLoading.value = true
        if validateFields() {
            AuthManager.login(withEmail: mail.value, password: password.value) { (success) in
                self.isLoading.value = false
                self.logged.value = success
            }
        } else {
            self.isLoading.value = false
            AlertHelper.showError(message: errorString)
        }
        
    }
    
    // MARK: Form Validation
    func validateFields() -> Bool {
        return validateWhiteSpaces() && validateEmail(mail.value) &&
            validatePasswordLength(password.value)
    }
    
    var errorString : String {
        var strings = [String]()
        
        if !validateWhiteSpaces() {
            strings.append("Preencha os campos vazios")
        } else {
            if !validateEmail(mail.value) {
                strings.append("Insira um email válido")
            }
            
            if !validatePasswordLength(password.value) {
                strings.append("A senha deve possuir no mínimo 6 caracteres")
            }
        }
        return strings.joined(separator: "\n")
    }
    
    func validateWhiteSpaces() -> Bool {
        if(mail.value == "" || password.value == "" || password.value == "") {
            return false
        }
        return true
    }
    
    func validateEmail(_ testString:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testString)
    }
    
    func validatePasswordEquality(_ pass1 : String, pass2 : String) -> Bool {
        if pass1 != pass2 {
            return false
        }
        return true
    }
    
    func validatePasswordLength(_ pass:String) -> Bool {
        if pass.count < 6 {
            return false
        }
        return true
    }
    
}
