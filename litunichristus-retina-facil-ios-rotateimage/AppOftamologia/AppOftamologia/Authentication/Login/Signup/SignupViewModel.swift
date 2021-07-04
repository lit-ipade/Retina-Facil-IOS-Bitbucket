//
//  SignupViewModel.swift
//  surgery-avaliation
//
//  Created by Jagni Dasa Horta Bezerra on 19/10/17.
//  Copyright © 2017 Unichristus. All rights reserved.
//

import Foundation
import RxSwift

class SignupViewModel : LoginViewModel {
    let passwordConfirmation = Variable<String>("")
    
    override init() {
        super.init()
        _ = Observable.combineLatest(self.mail.asObservable(), self.password.asObservable(), passwordConfirmation.asObservable()) { (email, pass, confirm) in
            return !email.isEmpty && !pass.isEmpty && !confirm.isEmpty
            }.bind(to: self.shouldEnableConfirm)
    }

    func signup() {
        isLoading.value = true
        if validateFields() {
            AuthManager.signup(withEmail: mail.value, password: password.value) { (success) in
                self.isLoading.value = false
                self.logged.value = success
            }
        } else {
            self.isLoading.value = false
            AlertHelper.showError(message: errorString)
        }
    }

    // MARK: Form Validation
    override func validateFields() -> Bool {
        return validateWhiteSpaces() && validateEmail(mail.value) &&
            validatePasswordLength(password.value) &&
            validatePasswordEquality(password.value, pass2: passwordConfirmation.value)
    }

    override var errorString : String {
        var string = super.errorString

        if string != "Preencha os campos vazios"{
            if !validatePasswordEquality(password.value, pass2: passwordConfirmation.value) {
                string += "A senha e sua confirmação devem ser iguais"
            }
        }
        return string
    }

}
