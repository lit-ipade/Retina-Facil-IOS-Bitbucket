//
//  GaleriaController.swift
//  AppOftamologia
//
//  Created by Felipe Martins on 21/11/17.
//  Copyright © 2017 Felipe Martins. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import SCLAlertView
import STPopup



class PatientTableController: UITableViewController {
    
    
    @IBAction func addPatientButton(_ sender: Any) {
        showAlert()
    }
        
    var patients = [Patient]()
    var userId = Auth.auth().currentUser?.uid as! String

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        //self.navigationController?.navigationBar. = self.editButtonItem
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        //FIRDatabase.database().pe
  
        
        firebaseRef!.child("users/\(userId)/patients").observe( .childAdded) { (snap : DataSnapshot) in
            if snap.hasChildren(){
                
                let dic = snap.value as! NSMutableDictionary
                
                self.patients.append( Patient(dict:dic) )
                
                self.tableView.reloadSections([0], with: .automatic)
            }
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
        return patients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PatientsViewCell
        
        let patient = patients[(indexPath as NSIndexPath).row]
        
        cell.patientName.text = patient.name
        
        cell.textLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel!.numberOfLines = 0
        //cell.detailTextLabel!.text = rowObject["dataCirurgia"] as? String
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func showAlert(){
        
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        
        //alertView.addButton("First Button", target:self, selector:Selector("firstButton"))
        let txt = alertView.addTextField("Nome")
        alertView.addButton("Adicionar") {
            print("Text value: \(txt.text)")
            self.createPatient(patientName: txt.text!)
        }
        
        alertView.addButton(NSLocalizedString("Cancelar", comment: ""), action: {
            
        })
        
        alertView.showSuccess("Novo paciente", subTitle: "Preencha o campo abaixo com o nome do paciente")
    }
    
    func createPatient(patientName: String){
        
        if(patientName != ""){
            
            var newPatient = Patient()
            newPatient.name = patientName
            newPatient.id = (Database.database().reference().childByAutoId()).key
            print(newPatient.id)
            FirebaseHelper.savePatient(newPatient)
            
            
            
        }
        
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let alertView = SCLAlertView()
        
        alertView.addButton(NSLocalizedString("Sim, deletar", comment: ""), action: {
            FirebaseHelper.deletePatient(self.patients[indexPath.row])
            self.patients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            //tableView.reloadEmptyDataSet()
        })
        
        alertView.showTitle("Atenção", subTitle: "Você está prestes a deletar o alarme do colírio \(patients[indexPath.row].id). Tem certeza?", style: SCLAlertViewStyle.warning, closeButtonTitle: "Não", timeout: nil, colorStyle: nil, colorTextButton: 0x242424, circleIconImage: nil, animationStyle: SCLAnimationStyle.bottomToTop)
      
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        currentPatient = patients[indexPath.row]
        performSegue(withIdentifier: "showPatientGalery", sender: nil)

/*
        let patient = patients[indexPath.row]
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "PatientGalery")
        let popupController = STPopupController(rootViewController: controller!)
        popupController.present(in: self)
        
        //showPatientGalery()
        
       
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "PatientGalery")
        let popupController = STPopupController(rootViewController: controller!)
        //popupController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: lightGrey]
        popupController.present(in: self)
         */
    }
}


