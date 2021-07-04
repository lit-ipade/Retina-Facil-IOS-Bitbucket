//
//  GaleriaExamesViewController.swift
//  GlaucoCheck
//
//  Created by Felipe Martins on 10/03/17.
//  Copyright © 2017 Felipe Martins. All rights reserved.
//

import UIKit
import SCLAlertView
import Photos
import AVFoundation
import CarbonKit
import Firebase
import STPopup

class GaleriaExamesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, CarbonTabSwipeNavigationDelegate {
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "Images") as! ImagemExamesViewController
        //controller.image = images[Int(index)].image!
        controller.view.backgroundColor = lightGrey
        return controller
    }
    
   /*
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var tabSwiper: CarbonTabSwipeNavigation!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var segmented: UISegmentedControl!
    @IBOutlet weak var dateLabel: UILabel!
    
    var eye : String {
        if segmented.selectedSegmentIndex == 0{
            return "olho_esquerdo"
        }
        else{
            return "olho_direito"
        }
    }
    
    var exam : String = ""
    var examNames = ["campo_visual" : "Campo Visual", "retinografia" : "Retinografia", "oct_nervos_fibras" : "OCT de Nervos e Fibras"]
    
    var images = [Image]()
    
    @IBAction func didChangeSegmented(_ sender: UISegmentedControl) {
        self.updateImages()
    }
   */
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.prompt = "Galeria - \(examNames[exam]!)"
        //pageControl.numberOfPages = images.count
    }
    
    
    func updateImages(){/*
        firebaseRef!.child("usuarios/\(Auth.auth().currentUser!.uid)/exames/galeria/\(exam)/\(eye)").observe(DataEventType.value) { (snap : DataSnapshot) in
            self.images = []
            var titles = [String]()
            if snap.hasChildren(){
                let dic = snap.value as! [String : NSMutableDictionary]
                for key in dic.keys{
                    self.images.append(Image(dic[key]!, id: key))
                    titles.append(key)
                }
                self.images.sort(by: { (p1, p2) -> Bool in
                    return p1.date!.compare(p2.date!) == ComparisonResult.orderedAscending
                })
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                if self.tabSwiper != nil{
                    self.tabSwiper.view.alpha = 0
                }
                self.pageControl.numberOfPages = self.images.count <= 1 ? 0 : self.images.count
            }, completion: { (finished) in
                if self.tabSwiper != nil{
                    self.tabSwiper.view.removeFromSuperview()
                }
                
                if self.images.count > 0{
                    self.tabSwiper = CarbonTabSwipeNavigation(items: titles, delegate: self)
                    self.tabSwiper.insert(intoRootViewController: self, andTargetView: self.containerView)
                    self.tabSwiper.view.alpha = 0
                    self.tabSwiper.view.backgroundColor = lightGrey
                    self.tabSwiper.setTabBarHeight(0)
                    self.tabSwiper.setIndicatorHeight(0)
                    self.dateLabel.text = self.images[0].getDateString()
                    UIView.animate(withDuration: 0.25, animations: {
                        self.emptyView.alpha = 0
                        self.tabSwiper.view.alpha = 1
                        self.editButtonItem.isEnabled = true
                    })
                }
                else{
                    UIView.animate(withDuration: 0.25, animations: {
                        self.emptyView.alpha = 1
                        self.editButtonItem.isEnabled = false
                    })
                }
            })
            
            firebaseRef?.removeAllObservers()
        }*/
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.view.setNeedsLayout()
        UIView.animate(withDuration: 0.25, animations: {
            self.navigationController?.view.layoutIfNeeded()
        })
        //updateImages()
    }
/*
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        self.dateLabel.text = images[Int(index)].getDateString()
        self.pageControl.currentPage = Int(index)
    }
    
    @IBAction func didTapRemove(_ sender: Any) {
    
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "Images") as! ImagemExamesViewController
        controller.image = images[Int(index)].image!
        controller.view.backgroundColor = lightGrey
        return controller
    }
    
  */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
