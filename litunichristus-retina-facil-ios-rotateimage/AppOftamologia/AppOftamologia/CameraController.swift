//
//  ViewController.swift
//  CameraTest
//
//  Created by Jagni Dasa Horta Bezerra on 27/08/18.
//  Copyright © 2018 Unichristus. All rights reserved.
//

import UIKit

class CameraController: UIViewController {


    @IBOutlet var cameraView : CameraView!
    
    @IBOutlet weak var zoomSlider : UISlider!
    @IBOutlet weak var flashlightSlider : UISlider!
    @IBOutlet weak var cameraPreview : CameraView!
    var completionBlock : ((UIImage?) -> Void)?

    @IBOutlet weak var flashlightSliderConstrain: NSLayoutConstraint!
    
    @IBAction func didTapPhoto(_ sender: Any) {
        cameraPreview.capturePhoto { (image) in
            self.dismiss(animated: true, completion: {
                if let completion = self.completionBlock {
                completion(image)
                }
            })
        }
    }

    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override open var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        let defaults = UserDefaults.standard
        var zoom = defaults.float(forKey: "zoom")
        if zoom >= 1 {
            zoom = 1
        }
        zoomSlider.value = zoom
        zoomSlider.addTarget(self, action: #selector(didPinch), for: UIControlEvents.valueChanged)
        
        flashlightSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-CGFloat.pi/2))
        cameraPreview.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        flashlightSliderConstrain.constant = -flashlightSlider.bounds.width/2 + 15;
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapToFocus(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        cameraPreview.addGestureRecognizer(tapRecognizer)
    
    }
    
    @IBAction func tapToFocus(_ sender: UITapGestureRecognizer) {
        if (sender.state == .ended) {
            cameraPreview.handleFocus(point: sender.location(in: cameraPreview));
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func didPinch(){
        let defaults = UserDefaults.standard
        defaults.set(zoomSlider.value, forKey: "zoom")
        cameraPreview.zoom(CGFloat(zoomSlider.value))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        UIApplication.shared.isIdleTimerDisabled = false
    }
    

    @IBAction func changeFlashLightLevel(_ sender: UISlider) {
        
        var level = sender.value
        if level < 0.1{
            level = 0.1
        }
        
        cameraView.changeFlashLevel(flashLevel: level)
        print("mudou para \(sender.value)")
    }
    
}

