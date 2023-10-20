//
//  CameraCell.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import AVFoundation
import UIKit

public class CameraCell: AppCollectionCell<CameraCellModel> {
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    private(set) lazy var cameraIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        previewLayer = nil
    }
    
    override func updateViews() {
        guard let model = self.cellModel else {
            return
        }
        
        self.backgroundColor = .red
        self.contentView.backgroundColor = .clear
        self.contentView.layer.cornerRadius = 10.0
        
        self.cameraIconImageView.image = AppAssets.Icon.camera.image?.withRenderingMode(.alwaysTemplate)
        self.cameraIconImageView.tintColor = .white
        contentView.addSubview(cameraIconImageView)
        
        cameraIconImageView.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.top.equalToSuperview().inset(4.0)
            $0.right.equalToSuperview().inset(4.0)
        }
        
        DispatchQueue(label: "camera", attributes: .concurrent).async {
            //self.setupComponents()
        }
    }
    
    #warning("todo camera")
    private func setupComponents() {
        let captureSession = AVCaptureSession()
        
        if let captureDevice = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(input)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        DispatchQueue.main.async {
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = self.bounds
            self.layer.addSublayer(previewLayer)
            
            self.previewLayer = previewLayer
        }
        
        captureSession.startRunning()
    }
}

