//
//  AboutViewController.swift
//  Projeto iOS
//
//  Created by Jagni Dasa Horta Bezerra on 15/09/17.
//  Copyright © 2017 Jagni Dasa Horta Bezerra. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController : UIViewController {
    
    @IBOutlet weak var aboutLabel: UILabel!
    var appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
    var version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    override func viewDidLoad() {
        //self.view.backgroundColor = appMainColor
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        var formattedString = NSMutableAttributedString()
        
        formattedString = formattedString.ultraLight("Retina fácil")
        
        formattedString = formattedString.small("\n\n\("Versão".localized())")
        formattedString = formattedString.bold("\n\(version)")
        formattedString = formattedString.normal("\n\nEsse aplicativo disponibiliza imagens e informações didáticas sobre o fundo de olho e sinais da retinopatia diabética, que podem ser utilizadas para o ensino na graduação médica e para atualização de médicos generalistas ou oftalmologistas.")
        
        //        formattedString = formattedString.normal("\n\nEsse aplicativo disponibiliza imagens e informações didáticas sobre o fundo de olho e sinais da retinopatia diabética, que podem ser utilizadas para o ensino na graduação médica e para atualização de médicos generalistas ou oftalmologistas.\n\nAs imagens são ferramentas fundamentais no exercício da oftalmologia e da telemedicina e o aplicativo torna a informação prontamente acessível\n\nEsperamos colaborar para a educação médica e facilitar o reconhecimento da retinopatia diabética e a tomada de condutas, contribuindo para a preservação da visão dos diabéticos.")
        let range = NSMakeRange(0, formattedString.length)
        formattedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: range)
        aboutLabel.attributedText = formattedString
    }
}
