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
    
    private(set) lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
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
    
    public func addCameraLayer(_ previewLayer: AVCaptureVideoPreviewLayer) {
        previewLayer.frame = self.bounds
        self.previewLayer = previewLayer
        self.previewLayer?.removeFromSuperlayer()
        self.containerView.layer.insertSublayer(previewLayer, at: 0)
    }
    
    override func updateViews() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.layer.cornerRadius = 10.0
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        
        self.cameraIconImageView.image = AppAssets.Icon.camera.image?.withRenderingMode(.alwaysTemplate)
        self.cameraIconImageView.tintColor = .white
        containerView.addSubview(cameraIconImageView)
        
        cameraIconImageView.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.top.equalToSuperview().inset(4.0)
            $0.right.equalToSuperview().inset(4.0)
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let event, event.type == .touches,
              let model = self.cellModel else {
            return
        }
        self.cellModel?.viewTapped?()
    }
}

