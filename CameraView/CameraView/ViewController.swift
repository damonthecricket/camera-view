//
//  ViewController.swift
//  CameraView
//
//  Created by Damon Cricket on 10.09.2019.
//  Copyright © 2019 DC. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cameraView: UIView?
    
    var session: AVCaptureSession?
    
    var stillImageOutput: AVCaptureStillImageOutput?
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    // MARK: - Object LifeCycle
    
    deinit {
        session?.stopRunning()
        session = nil
        
        stillImageOutput = nil
        
        videoPreviewLayer = nil
    }
    
    // MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = AVCaptureSession()
        session?.sessionPreset = .photo
        
        let backCamera = AVCaptureDevice.default(for: .video)
        var input: AVCaptureDeviceInput?
        var error: NSError?
        
        do {
            input = try AVCaptureDeviceInput(device: backCamera!)
        } catch let err as NSError {
            error = err
            input = nil
            print("Error: \(error!.localizedDescription)")
        }
        
        if error == nil && session!.canAddInput(input!) {
            session?.addInput(input!)
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecType.jpeg]
            
            if session!.canAddOutput(stillImageOutput!) {
                session!.addOutput(stillImageOutput!)
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
                videoPreviewLayer!.videoGravity = .resizeAspect
                videoPreviewLayer?.connection?.videoOrientation = .portrait
                videoPreviewLayer?.frame = cameraView!.bounds
                cameraView?.layer.addSublayer(videoPreviewLayer!)

                session?.startRunning()
            }
        }
    }


}

