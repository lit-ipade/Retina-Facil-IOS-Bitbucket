//
//  MainViewController.swift
//  AppOftamologia
//
//  Created by Felipe Martins on 23/11/17.
//  Copyright © 2017 Felipe Martins. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import MBProgressHUD
import SCLAlertView

class MainViewController: UIViewController {
    
    var quiz : [Question] = []
    var matricula:String?
    var name:String?

    @IBAction func didTapLogout(_ sender: UIBarButtonItem?) {
        let appearance = SCLAlertView.SCLAppearance(kDefaultShadowOpacity: 1, showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)

        alertView.addButton(NSLocalizedString("Sim", comment: ""), action: {
            AuthManager.logout()

            let rootController = self.storyboard?.instantiateViewController(withIdentifier: "root")

            UIApplication.shared.keyWindow?.rootViewController = rootController
            UIApplication.shared.keyWindow?.makeKeyAndVisible()

            let loginController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationLogin")
            rootController?.present(loginController!, animated: true, completion: nil)
        })

        alertView.addButton(NSLocalizedString("Não", comment: ""), action: {
            alertView.dismiss(animated: true, completion: nil)
        })

        alertView.showTitle("Atenção", subTitle: "Deseja realmente fazer logout?", style: SCLAlertViewStyle.warning, closeButtonTitle: nil, timeout: nil, colorStyle: nil, colorTextButton: 0x000000, circleIconImage: nil, animationStyle: SCLAnimationStyle.bottomToTop)


    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.title = " "
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Retina Fácil"
        firebaseRef?.removeAllObservers()
        
        if #available(iOS 11.0, *), UIDevice.current.userInterfaceIdiom == .phone{
            navigationItem.largeTitleDisplayMode = .always
            
            self.navigationController?.navigationBar.largeTitleTextAttributes![NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.bold)
        }
        
        if(quiz.count == 0){
            self.getQuiz()
        }
        
        
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
    
    @IBAction func showFundoOlhoSheets(_ sender: Any) {
        performSegue(withIdentifier: "showSheet", sender: "olhonormal")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "showSheet"){
            let path = sender as! String
            let destination = segue.destination as! HomeViewController
            destination.titleName = "Fundo de olho normal"
            
            destination.path = path
        } else{
            if(segue.identifier == "showQuiz"){                
                let destination = segue.destination as! QuizNavigationController
                destination.quiz = quiz
            }
        }
        
    }
    
    func getQuiz(){
        
        
        firebaseRef!.child("quiz").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChildren(){
                
                let quizDict = snapshot.value as? NSDictionary
                
                
                for key in (quizDict?.allKeys)!{

                    let questionDict = quizDict![key] as! NSDictionary
                    let question = Question(dict: questionDict)
                    
                    self.quiz.append(question)
                }
                
            }
            
            //self.quiz.shuffle()

            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
}
