//
//  TutorialViewController.swift
//  Projeto iOS
//
//  Created by Jagni Dasa Horta Bezerra on 19/09/17.
//  Copyright © 2017 Jagni Dasa Horta Bezerra. All rights reserved.
//

import Foundation
import UIKit
import paper_onboarding

class TutorialViewController : UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        switch index{
            
        case 0 :
            return OnboardingItemInfo(informationImage: UIImage(named: "applogo")!, title: "Retina Fácil", description: "Esse aplicativo disponibiliza imagens e informações didáticas sobre o fundo de olho e sinais da retinopatia diabética, que podem ser utilizadas para o ensino na graduação médica e para atualização de médicos generalistas ou oftalmologistas.", pageIcon: UIImage(), color: appMainColor, titleColor: appWhiteColor, descriptionColor: appWhiteColor, titleFont: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy), descriptionFont: UIFont.systemFont(ofSize: 16))
            
        case 1 :
            return OnboardingItemInfo(informationImage: UIImage(named: "applogo")!, title: "Retina Fácil", description: "As imagens  são ferramentas fundamentais no exercício da oftalmologia e da telemedicina e  o aplicativo torna a informação prontamente acessível.", pageIcon: UIImage(), color: appOrangeColor, titleColor: appWhiteColor, descriptionColor: appWhiteColor, titleFont: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy), descriptionFont: UIFont.systemFont(ofSize: 16))
            
        case 2:
            return OnboardingItemInfo(informationImage: UIImage(named: "applogo")!, title: "Retina Fácil", description: "Esperamos colaborar para a educação médica e facilitar o reconhecimento da retinopatia diabética e a tomada de condutas,  contribuindo para a preservação da visão dos diabéticos.", pageIcon: UIImage(), color: appMainColor, titleColor: appWhiteColor, descriptionColor: appWhiteColor, titleFont: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy), descriptionFont: UIFont.systemFont(ofSize: 16))
            
        default:
            return OnboardingItemInfo(informationImage: UIImage(), title: "", description: "", pageIcon: UIImage(), color: appMainColor, titleColor: appWhiteColor, descriptionColor: appWhiteColor, titleFont: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy), descriptionFont: UIFont.systemFont(ofSize: 15))
            break
            
            
        }
        
        
    }
    
    @IBOutlet var onboard : PaperOnboarding!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboard.delegate = self
    }
    
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingWillTransitonToIndex(_ index: Int){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            if self.navigationController != nil && index == 1 {
                self.navigationController?.navigationBar.barTintColor = appOrangeColor
            } else {
                self.navigationController?.navigationBar.barTintColor = appMainColor
            }
        }
        
        if index == 2 {
            
            self.view.setNeedsLayout()
            
            UIView.animate(withDuration: 1, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        
    }
    
    func onboardingDidTransitonToIndex(_ index: Int){
        
        
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if self.navigationController != nil {
            self.navigationController?.navigationBar.barTintColor = appMainColor
        }
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        item.imageView?.tintColor = appWhiteColor
    }
    
}
