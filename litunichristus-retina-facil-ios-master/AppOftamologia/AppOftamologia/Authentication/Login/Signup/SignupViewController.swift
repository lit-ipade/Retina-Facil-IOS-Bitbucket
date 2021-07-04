//
//  SignupViewController.swift
//  Habits
//
//  Created by Jagni Dasa Horta Bezerra on 14/09/15.
//  Copyright (c) 2015 Jordão Memória. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SignupViewController:  UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    var viewModel = SignupViewModel()

    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldPasswordAgain: UITextField!
    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var layoutConstraintCenter: NSLayoutConstraint!
    
    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldPassword.text = viewModel.password.value
        self.textFieldEmail.text = viewModel.passwordConfirmation.value
        self.groupView.layer.borderWidth = 1
        self.groupView.layer.borderColor = appMainColor.cgColor
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
        
        _ = textFieldEmail.rx.text.orEmpty.bind(to: viewModel.mail)
        _ = textFieldPassword.rx.text.orEmpty.bind(to: viewModel.password)
        _ = textFieldPasswordAgain.rx.text.orEmpty.bind(to: viewModel.passwordConfirmation)

        _ = viewModel.logged.asObservable().subscribe { (logged) in
            if logged.element ?? false {
                self.dismiss(animated: true, completion: nil)
            }
        }

        _ = viewModel.shouldEnableConfirm.asObservable().subscribe { (confirmed) in
            let confirm = confirmed.element ?? false
            self.confirmButton.isEnabled = confirm
            if  confirm {
                self.confirmButton.backgroundColor = UIColor.clear
            } else {
                self.confirmButton.backgroundColor = disabledGray
            }
        }

        _ = viewModel.isLoading.asObservable().subscribe { (loading) in
            if loading.element ?? false {
                self.showProgressHUD()
            } else {
                self.hideProgressHUD()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        self.groupView.layer.cornerRadius = 6
        self.groupView.clipsToBounds = true
    }

    var progressHUD : MBProgressHUD?
    func showProgressHUD() {
        progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        progressHUD?.labelText = "Conectando..."
        progressHUD?.mode = .indeterminate
    }

    func hideProgressHUD() {
        progressHUD?.hide(true)
    }
    
    @IBAction func signup(_ sender: AnyObject) {
        viewModel.signup()
    }
    
    @IBAction func backLogin(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }

    // MARK: - Animações
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        textFieldEmail.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        textFieldPasswordAgain.resignFirstResponder()
        finishAnimations()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad {
            startAnimations()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldEmail {
            textFieldPassword.becomeFirstResponder()
        } else if textField == textFieldPassword {
            textFieldPasswordAgain.becomeFirstResponder()
        } else if textField == textFieldPasswordAgain {
            signup("" as AnyObject)
        }
        
        return true
    }
    
    func startAnimations() {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.imageViewLogo.alpha = 0
            self.layoutConstraintCenter.constant = -(self.view.frame.height/2 - 152)
            self.view.layoutIfNeeded()
        }) 
    }
    
    func finishAnimations() {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.imageViewLogo.alpha = 1
            self.layoutConstraintCenter.constant = 0
            self.view.layoutIfNeeded()
        }) 
    }
    
    //Animação da logo com giroscópio
    func setupMotionEffect() {
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
