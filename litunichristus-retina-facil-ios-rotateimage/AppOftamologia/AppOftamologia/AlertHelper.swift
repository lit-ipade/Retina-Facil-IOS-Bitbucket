//
//  AlertHelper.swift
//  Habits
//
//  Created by Jordão Memória on 10/7/15.
//  Copyright © 2015 Jordão Memória. All rights reserved.
//

import UIKit
import SCLAlertView

class AlertHelper {
    
    class func showHelp(message: String) {
        
        SCLAlertView().showTitle("Ajuda", subTitle: message, style: SCLAlertViewStyle.info, closeButtonTitle: "Ok", timeout: nil, colorStyle: 0x24b3ae, colorTextButton: 0xF4F4F9, circleIconImage: nil, animationStyle: SCLAnimationStyle.bottomToTop)
    }
    
    class func showInfo(message: String) {
        
        SCLAlertView().showTitle("Instrução", subTitle: message, style: SCLAlertViewStyle.info, closeButtonTitle: "Ok", timeout: nil, colorStyle: 0x24b3ae, colorTextButton: 0xF4F4F9, circleIconImage: nil, animationStyle: SCLAnimationStyle.bottomToTop)
    }
    
    class func showError(message:String) {
        
        SCLAlertView().showTitle("Erro", subTitle: message, style: SCLAlertViewStyle.error, closeButtonTitle: "Ok", timeout: nil, colorStyle: nil, colorTextButton: 0xF4F4F9, circleIconImage: nil, animationStyle: SCLAnimationStyle.bottomToTop)
    }
    
    class func showAlert(message: String) {
        SCLAlertView().showTitle("Atenção", subTitle: message, style: SCLAlertViewStyle.warning, closeButtonTitle: "Ok", timeout: nil, colorStyle: nil, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.bottomToTop)
    }
    
    class func showAlert(message: String, confirmButton: String, cancelButton: String, completion: @escaping (Bool) -> Void) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton(confirmButton, action: {
            completion(true)
            alertView.dismiss(animated: true, completion: nil)
        })
        
        alertView.addButton(cancelButton, action: {
            completion(false)
            alertView.dismiss(animated: true, completion: nil)
        })
        
        alertView.showTitle("Atenção", subTitle: message, style: SCLAlertViewStyle.warning, closeButtonTitle: "", timeout: nil, colorStyle: nil, colorTextButton: 0x242424, circleIconImage: nil, animationStyle: SCLAnimationStyle.bottomToTop)
    }
    
    class func showSuccess(message:String) {
        
        SCLAlertView().showTitle("Sucesso", subTitle: message, style: SCLAlertViewStyle.success, closeButtonTitle: "Ok", timeout: nil, colorStyle: 0x24b3ae, colorTextButton: 0xF4F4F9, circleIconImage: nil, animationStyle: SCLAnimationStyle.bottomToTop)
    }
    
}
