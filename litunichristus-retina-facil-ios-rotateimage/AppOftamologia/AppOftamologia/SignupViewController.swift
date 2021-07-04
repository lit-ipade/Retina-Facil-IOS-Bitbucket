//
//  SignupViewController.swift
//  Habits
//
//  Created by Jagni Dasa Horta Bezerra on 14/09/15.
//  Copyright (c) 2015 Jordão Memória. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SignupViewController:  UIViewController, UITextFieldDelegate{
    
    //MARK: Propriedades
    var email : String?
    var password : String?
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldPasswordAgain: UITextField!
    @IBOutlet weak var imageViewLogo: JMShadowImageView!
    @IBOutlet weak var groupView: JMShadowView!
    @IBOutlet weak var textViewPolicyAndTerms: UITextView!
    @IBOutlet weak var layoutConstraintCenter: NSLayoutConstraint!
    
    //MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldPassword.text = self.password
        self.textFieldEmail.text = self.email
        textFieldPassword.delegate = self
        textFieldPasswordAgain.delegate = self
        textFieldEmail.delegate = self
        setupMotionEffect()
        
        let inImage = imageViewLogo.image!
        
        //*3 por causa do @3x
        UIGraphicsBeginImageContext(CGSize(width: imageViewLogo.bounds.width * 3, height: imageViewLogo.bounds.height * 3))
        
        //Transformando a imagem para criar um espaço em volta
        inImage.draw(in: CGRect(x: imageViewLogo.bounds.width * 0.25, y: imageViewLogo.bounds.width * 0.25, width: imageViewLogo.bounds.width * 2.5, height: imageViewLogo.bounds.height * 2.5))
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        imageViewLogo.image = newImage
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        
        self.groupView.layer.cornerRadius = 6
        self.groupView.clipsToBounds = true
    }
    
    //MARK: SignupViewController
    
    @IBAction func signup(_ sender: AnyObject) {
        
        if validateTextFields(){
            
            FIRAuth.auth()?.createUser(withEmail: textFieldEmail.text!, password: textFieldPassword.text!) { (user, error) in
                
                if user != nil{
                    currentUser = User()
                    currentUser!.email = FIRAuth.auth()!.currentUser!.email!
                    
                    FirebaseHelper.saveUser(currentUser!)
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }
                else{
                    
                    AlertHelper.showError(message: "Não foi possível estabelecer uma conexão com o servidor")
                    
                }
                
            }
            
        }
        else{
            
            AlertHelper.showError(message: self.createErrorString())
            
        }
        
    }
    
    @IBAction func backLogin(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Validação
    
    func validateTextFields() -> Bool{
        return validateWhiteSpaces() && validateEmail(textFieldEmail.text!) && validatePasswordEquality(textFieldPassword.text!, p2: textFieldPasswordAgain.text!) && (validatePasswordLength(textFieldPassword.text!) || validatePasswordLength(textFieldPasswordAgain.text!))
    }
    
    func createErrorString() -> String{
        
        var errorString = ""
        
        if !validateWhiteSpaces(){
            errorString += "Preencha os campos vazios \n"
        }
        else{
            if !validateEmail(textFieldEmail.text!){
                errorString += "Insira um email válido \n"
            }
            
            if !validatePasswordEquality(textFieldPassword.text!, p2: textFieldPasswordAgain.text!){
                errorString += "A senha e sua confirmação devem ser iguais \n"
            }
            
            if !validatePasswordLength(textFieldPassword.text!) || !validatePasswordLength(textFieldPasswordAgain.text!){
                errorString += "A senha deve possuir no mínimo 6 caracteres \n"
            }
        }
        
        
        
        return errorString
        
    }
    
    func validateWhiteSpaces()->Bool{
        if(textFieldEmail.text == "" || textFieldPassword.text == "" || textFieldPasswordAgain.text == ""){
            return false
        }
        return true
    }
    
    func validateEmail(_ testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func validatePasswordEquality(_ p1:String,p2:String)->Bool{
        if p1 != p2 {
            return false
        }
        return true
    }
    
    func validatePasswordLength(_ p1:String) -> Bool{
        if p1.characters.count < 6{
            return false
        }
        return true
    }
    
    //MARK:  - Animações
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        textFieldEmail.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        textFieldPasswordAgain.resignFirstResponder()
        finishAnimations()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        startAnimations()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldEmail{
            textFieldPassword.becomeFirstResponder()
        }
        else if textField == textFieldPassword{
            textFieldPasswordAgain.becomeFirstResponder()
        }
        else if textField == textFieldPasswordAgain{
            signup("" as AnyObject)
        }
        
        return true
    }
    
    func startAnimations(){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.imageViewLogo.alpha = 0
            self.layoutConstraintCenter.constant = -(self.view.frame.height/2 - 152)
            self.view.layoutIfNeeded()
        }) 
    }
    
    func finishAnimations(){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.imageViewLogo.alpha = 1
            self.layoutConstraintCenter.constant = 0
            self.view.layoutIfNeeded()
        }) 
    }
    
    //Animação da logo com giroscópio
    func setupMotionEffect(){
        let motionEffetctH = UIInterpolatingMotionEffect(keyPath: "contentsRect.origin.x", type: UIInterpolatingMotionEffectType.tiltAlongHorizontalAxis)
        motionEffetctH.minimumRelativeValue = -0.07
        motionEffetctH.maximumRelativeValue = 0.07
        
        let motionEffetctV = UIInterpolatingMotionEffect(keyPath: "contentsRect.origin.y", type: UIInterpolatingMotionEffectType.tiltAlongVerticalAxis)
        motionEffetctV.minimumRelativeValue = -0.07
        motionEffetctV.maximumRelativeValue = 0.07
        
        imageViewLogo.addMotionEffect(motionEffetctH)
        imageViewLogo.addMotionEffect(motionEffetctV)
        
        
        let motionShadowH = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset.width", type: UIInterpolatingMotionEffectType.tiltAlongHorizontalAxis)
        motionShadowH.minimumRelativeValue = -10
        motionShadowH.maximumRelativeValue = 10
        
        let motionShadowV = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset.height", type: UIInterpolatingMotionEffectType.tiltAlongVerticalAxis)
        motionShadowV.minimumRelativeValue = -10
        motionShadowV.maximumRelativeValue = 10
        
        imageViewLogo.addMotionEffect(motionShadowH)
        imageViewLogo.addMotionEffect(motionShadowV)
        groupView.addMotionEffect(motionShadowH)
        groupView.addMotionEffect(motionShadowV)
    }
    
    
}


