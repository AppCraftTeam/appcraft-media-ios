//
//  CameraCell.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import AVFoundation
import DPUIKit
import UIKit

open class CameraCell: DPCollectionItemCell {
    
    // MARK: - Props
    var model: CameraCellModel? {
        get { self._model as? CameraCellModel }
        set { self._model = newValue }
    }
    
    // Layout for camera
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    // MARK: - Components
    private(set) lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = model?.configuration.appearance.backgroundColor
        
        return view
    }()
    
    private(set) lazy var cameraIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // MARK: - Methods
    public override func setupComponents() {
        super.setupComponents()
        
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
        
        self.cameraIconImageView.image = ACAppAssets.Icon.camera.image?.withRenderingMode(.alwaysTemplate)
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
    
    open override func updateComponents() {
        super.updateComponents()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        previewLayer = nil
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.backgroundColor = .clear
        self.containerView.layer.cornerRadius = model?.configuration.appearance.previewCardCornerRadius ?? 0.0
    }
    
    open func addCameraLayer(_ previewLayer: AVCaptureVideoPreviewLayer) {
        previewLayer.frame = self.bounds
        self.previewLayer = previewLayer
        self.previewLayer?.removeFromSuperlayer()
        self.containerView.layer.insertSublayer(previewLayer, at: 0)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let event, event.type == .touches else {
            return
        }
        self.model?.viewTapped?()
    }
}

// MARK: - Types
extension CameraCell {
    typealias Adapter = DPCollectionItemAdapter<CameraCell, CameraCellModel>
}
