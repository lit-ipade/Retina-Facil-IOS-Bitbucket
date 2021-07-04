//
//  ConceitosTableController.swift
//  AppOftamologia
//
//  Created by Laboratorio de Inovações Tecnologicas on 04/04/2018.
//  Copyright © 2018 Felipe Martins. All rights reserved.
//

import Foundation

class ConceitosTableController: UITableViewController{
    
    let subjects =  ["Epidemiologia e fatores de risco","Fisiopatogenia", "Classificação da Retinopatia diabética e Edema macular","Rastreamento e orientações","Imagens da Retinopatia diabética"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        if #available(iOS 11.0, *), UIDevice.current.userInterfaceIdiom == .phone{
            navigationItem.largeTitleDisplayMode = .always
            
            self.navigationController?.navigationBar.largeTitleTextAttributes![NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.bold)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //Cria as linhas em uma sessão da Table
        return subjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConceitoCell", for: indexPath)
        
        let title = subjects[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = title
        
        cell.textLabel!.numberOfLines = 0
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row{
            
        case 0:
            performSegue(withIdentifier: "showEpidemiologia", sender: nil)
        
        case 1:
            performSegue(withIdentifier: "showFisiopatogenia", sender: nil)
            
        case 2:
            performSegue(withIdentifier: "showClassificacao", sender: nil)
            
        case 3:
            performSegue(withIdentifier: "showOrientacoes", sender: nil)

        case 4:
            performSegue(withIdentifier: "showImagemRD", sender: "retinoplastia/conceitos")
            

            
        default:
            break
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if(segue.identifier == "showImagemRD"){
            let path = sender as! String
            let destination = segue.destination as! HomeViewController
            destination.titleName = "Imagens de Retinopatia diabética"
            
            destination.path = path
        }
   
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        
        //self.navigationController?.title = "Conceitos Gerais"
        
        if #available(iOS 11.0, *), UIDevice.current.userInterfaceIdiom == .phone{
            navigationItem.largeTitleDisplayMode = .always
            
            self.navigationController?.navigationBar.largeTitleTextAttributes![NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.bold)
        }
    }
    
    
}


class ConceitosCell: UITableViewCell{
    
    @IBOutlet weak var title: UILabel!
}
