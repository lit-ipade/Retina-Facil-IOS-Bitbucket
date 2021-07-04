//
//  CameraView.swift
//  CameraTest
//
//  Created by Jagni Dasa Horta Bezerra on 27/08/18.
//  Copyright © 2018 Unichristus. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

final class CameraView: UIView {

    var completionBlock : ((UIImage?) -> Void)?

    private lazy var photoOutput: AVCapturePhotoOutput = {
        let p = AVCapturePhotoOutput()

        p.isHighResolutionCaptureEnabled = true
        p.isLivePhotoCaptureEnabled = false
        return p
    }()

    private lazy var videoDataOutput: AVCaptureVideoDataOutput = {
        let v = AVCaptureVideoDataOutput()

        v.alwaysDiscardsLateVideoFrames = true
        v.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        v.connection(with: .video)?.isEnabled = true
        return v
    }()

    private let videoDataOutputQueue: DispatchQueue = DispatchQueue(label: "JKVideoDataOutputQueue")
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let l = AVCaptureVideoPreviewLayer(session: session)
        l.videoGravity = AVLayerVideoGravity.resizeAspectFill
        return l
    }()

    private let captureDevice: AVCaptureDevice? = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)

    private lazy var session: AVCaptureSession = {
        let s = AVCaptureSession()
        s.sessionPreset = .vga640x480
        return s
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private func commonInit() {
        contentMode = .scaleAspectFill
        beginSession()
    }

    private func beginSession() {
        do {
            guard let captureDevice = captureDevice else {
                fatalError("Camera doesn't work on the simulator! You have to test this on an actual device!")
            }
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            if session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
            }

            if session.canAddOutput(videoDataOutput) {
                session.addOutput(videoDataOutput)

                self.session.beginConfiguration()
                self.session.sessionPreset = .photo
                self.session.commitConfiguration()

                session.addOutput(photoOutput)
            }
            layer.masksToBounds = true
            layer.addSublayer(previewLayer)
            previewLayer.frame = bounds

            session.startRunning()

            let defaults = UserDefaults.standard
            var zoom = defaults.float(forKey: "zoom")
            if zoom <= 1 {
                zoom = 1
            }
            self.zoom(CGFloat(zoom))
        } catch let error {
            debugPrint("\(self.self): \(#function) line: \(#line).  \(error.localizedDescription)")
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = bounds
    }

    func capturePhoto(completion: @escaping (UIImage?) -> Void){
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.flashMode = .off
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
        completionBlock = completion
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {

        if let completion = self.completionBlock, let file = photo.fileDataRepresentation()
            {
			let takenImage = UIImage(data: file)!

            let outputRect = self.previewLayer.metadataOutputRectConverted(fromLayerRect: previewLayer.bounds)

            let takenCGImage = takenImage.cgImage!

            let width = CGFloat(takenCGImage.width)
            let height = CGFloat(takenCGImage.height)

            let cropRect = CGRect(x: outputRect.origin.x * width, y: outputRect.origin.y * height, width: outputRect.size.width * width, height: outputRect.size.height * height)

            let croppedCGImage = takenCGImage.cropping(to: cropRect)

            let croppedImage = UIImage(cgImage: croppedCGImage!, scale: 1, orientation: takenImage.imageOrientation)


            completion(croppedImage)
        }
    }

    func zoom(_ vZoomFactor: CGFloat) {
        if let device = captureDevice {
            var error:NSError!
            do{
                try device.lockForConfiguration()
                var factor = vZoomFactor
                defer {device.unlockForConfiguration()}
                if (factor <= device.activeFormat.videoMaxZoomFactorForDepthDataDelivery && factor > 1){
                    device.videoZoomFactor = factor
                } else{
                    NSLog("Unable to set videoZoom: (max %f, asked %f)", device.activeFormat.videoMaxZoomFactor, factor);
                }
            }catch error as NSError{
                NSLog("Unable to set videoZoom: %@", error.localizedDescription);
            }catch _{

            }
        }
    }
}

extension CameraView: AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate {}
