//
//  SheetInfoController.swift
//  AppOftamologia
//
//  Created by Jagni Dasa Horta Bezerra on 08/02/2018.
//  Copyright © 2018 Felipe Martins. All rights reserved.
//

import UIKit


class SheetInfoController: UIViewController, UIScrollViewDelegate {
    
    //var sheets = [Sheet]!
    var image : UIImage!
    var discription: String!
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var previusButton: UIBarButtonItem!
    
    @IBOutlet var imageView: UIImageView!

    @IBOutlet weak var descriptionTextView: UITextView!
 
//    @IBAction func cancel(_ sender: Any) {
//
//        self.dismiss(animated: true, completion: nil)
//
//    }
//
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func next(_ sender: Any) {

        sheetIndex = sheetIndex + 1

        let nextController = self.storyboard?.instantiateViewController(withIdentifier: "SheetInfo")

        self.navigationController?.show(nextController!, sender: nil)

    }

    @IBAction func back(_ sender: Any) {

       sheetIndex = sheetIndex - 1
       self.navigationController?.popViewController(animated: true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationItem.leftBarButtonItem = navigationItem.leftBarButtonItems.cancel
        
        let sheet = sheets[sheetIndex]
        
        self.imageView.image = UIImage(named: sheet.image)!
        self.descriptionTextView.text = sheet.discription
        self.descriptionTextView.setContentOffset(CGPoint.zero, animated: false)
        
        self.navigationItem.title = sheet.name
        
        
        if(self.navigationController?.childViewControllers.count == 1){
            previusButton.isEnabled = false
        }
        
        if(sheetIndex == sheets.count - 1 ){
            nextButton.isEnabled = false
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //super.viewDid
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        //tipView.dismiss()
        super.viewWillDisappear(true)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        let path = sender as! String
        let destination = segue.destination as! HomeViewController
            
        destination.path = path
        
    }

}
