//
//  AddGalleryExamController.swift
//  GlaucoCheck
//
//  Created by Jagni Dasa Horta Bezerra on 21/08/17.
//  Copyright © 2017 Felipe Martins. All rights reserved.
//

import Foundation

class AddGalleryExamController : UIViewController, UIScrollViewDelegate, UITextFieldDelegate{

    var image : UIImage!
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    var eye : String!
    var exam : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Novo exame"
        imageView.image = image
        
        dateTextField.inputAccessoryView = createToolbar()
        
        let formaterDate = DateFormatter()
        formaterDate.dateFormat = "dd/MM/yyyy"
        dateTextField.text = formaterDate.string(from: Date())
        
        var bigger = max(self.view.frame.width, self.view.frame.height)
        bigger = min(bigger, 600)
        var smaller = min(self.view.frame.width, self.view.frame.height)
        smaller = min (smaller, 500)
        self.contentSizeInPopup = CGSize(width: smaller*0.8, height: bigger*0.7)
        self.landscapeContentSizeInPopup = CGSize(width: bigger*0.75, height: smaller*0.75);
    }
    
    func createToolbar() -> UIToolbar{
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = false
        toolBar.tintColor = appMainColorLight
        toolBar.barTintColor = appMainColorLight
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: nil)
        doneButton.tintColor = lightGrey
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
/*
    @IBAction func dateSelect(_ sender: Any) {
        let formaterDate = DateFormatter()
        formaterDate.dateFormat = "dd/MM/yyyy"
        dateTextField.text = formaterDate.string(from: datePicker.date)
    }
    
    @objc func donePicker (_ sender: AnyObject){
        self.dateTextField.resignFirstResponder()
    }
 */
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @IBAction func save(_ sender : Any){
    
        let image = Image()
        image.date = Date()
        image.image = self.image
        FirebaseHelper.saveImage(image, patientId: currentPatient.id)
        self.dismiss(animated: true, completion: nil)
        print("Salvar No Banco")
    }
    
}
