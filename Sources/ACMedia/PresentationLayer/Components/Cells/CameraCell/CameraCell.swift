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
        view.backgroundColor = ACMediaConfiguration.shared.appearance.backgroundColor
        
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.backgroundColor = .clear
        self.containerView.layer.cornerRadius = ACMediaConfiguration.shared.appearance.previewCardCornerRadius
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
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        self.cameraIconImageView.image = AppAssets.Icon.camera.image?.withRenderingMode(.alwaysTemplate)
        self.cameraIconImageView.tintColor = .white
        containerView.addSubview(cameraIconImageView)
        
        cameraIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraIconImageView.widthAnchor.constraint(equalToConstant: 44),
            cameraIconImageView.heightAnchor.constraint(equalToConstant: 44),
            cameraIconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4.0),
            cameraIconImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4.0)
        ])
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let event, event.type == .touches else {
            return
        }
        self.cellModel?.viewTapped?()
    }
}
