//
//  ViewController.swift
//  AppOftamologia
//
//  Created by Felipe Martins on 21/11/17.
//  Copyright © 2017 Felipe Martins. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FIRAuth.auth()?.currentUser == nil{
            //let progressHud = MBProgressHUD.showAdded(to: view, animated: true)
            //progressHud?.labelText = "Conectando..."
            //progressHud?.mode = MBProgressHUDModeIndeterminate
            self.view.isUserInteractionEnabled = false
            FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
                if user != nil{
                    //progressHud?.hide(true);
                    self.view.isUserInteractionEnabled = true
                }
            })
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.title = " "
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "AppOftamologia"
        firebaseRef?.removeAllObservers()
        //FIRDatabaseReference.removeAllObservers()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.view.setNeedsLayout()
        UIView.animate(withDuration: 0.25, animations: {
            self.navigationController?.view.layoutIfNeeded()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

