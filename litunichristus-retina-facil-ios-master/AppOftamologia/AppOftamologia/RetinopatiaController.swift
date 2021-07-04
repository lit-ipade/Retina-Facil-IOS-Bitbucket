//
//  RetinopatiaController.swift
//  AppOftamologia
//
//  Created by Laboratorio de Inovações Tecnologicas on 14/03/2018.
//  Copyright © 2018 Felipe Martins. All rights reserved.
//

import Foundation

class RetinopatiaController: UIViewController{
    
    @IBOutlet weak var setsRDP: UIImageView!
    @IBOutlet weak var setaRDNP: UIImageView!
    @IBOutlet weak var rdnpText: UILabel!
    @IBOutlet weak var rdp: UILabel!
    @IBAction func clickNaoProlifetativa(_ sender: Any) {
        
        performSegue(withIdentifier: "showRetinoSheet", sender: "retinoplastia/naoproliferativa")
    }
    
    @IBAction func clickProliferativa(_ sender: Any) {
        
        performSegue(withIdentifier: "showRetinoSheet", sender: "retinoplastia/proliferativa")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        rdnpText.text = "Retinopatia Diabética não Proliferativa (RDNP)\n -Leve\n -Moderada\n -Grave"
        rdp.text = "Retinopatia Diabética Proliferativa (RDP)\n -Baixo risco\n -Alto risco\n -Doença ocular diabética avançada"
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Retinopatia Diabética"
        
        setsRDP.transform = CGAffineTransform(rotationAngle: .pi)
        setsRDP.tintColor = appMainColor
        
        setaRDNP.transform = CGAffineTransform(rotationAngle: .pi)
        setaRDNP.tintColor = appMainColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let path = sender as! String
        let destination = segue.destination as! HomeViewController
            
        destination.path = path
        if(path == "retinoplastia/naoproliferativa"){
            destination.titleName = "Retinopatia diabética não proliferativa"
        }
        else{
            destination.titleName = "Retinopatia diabética proliferativa"
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = ""
    }
}
