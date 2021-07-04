//
//  ViewController.swift
//  CameraTest
//
//  Created by Jagni Dasa Horta Bezerra on 27/08/18.
//  Copyright © 2018 Unichristus. All rights reserved.
//

import UIKit

class CameraController: UIViewController {


    @IBOutlet weak var zoomSlider : UISlider!
    @IBOutlet weak var cameraPreview : CameraView!
    var completionBlock : ((UIImage?) -> Void)?

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
        let defaults = UserDefaults.standard
        var zoom = defaults.float(forKey: "zoom")
        if zoom <= 1 {
            zoom = 1
        }
        zoomSlider.value = zoom
        zoomSlider.addTarget(self, action: #selector(didPinch), for: UIControlEvents.valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func didPinch(){
        let defaults = UserDefaults.standard
        defaults.set(zoomSlider.value, forKey: "zoom")
        cameraPreview.zoom(CGFloat(zoomSlider.value))
    }


}

