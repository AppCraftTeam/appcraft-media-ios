//
//  ACPhotoPreviewViewModel.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import Photos
import UIKit

/// ViewModel for `ACPhotoPreviewViewController`
open class ACPhotoPreviewViewModel {
        
    // MARK: - Properties
    var configuration: ACMediaConfiguration
    var image: UIImage?
    private var asset: PHAsset?
    private var photoService = ACPhotoService()
    
    // MARK: - Actions
    var onSetImage: ((_ image: UIImage) -> Void)?
    
    init(configuration: ACMediaConfiguration, asset: PHAsset?) {
        self.configuration = configuration
        self.asset = asset
    }
    
    /// Load original photo
    /// - Parameter size: photo size
    func loadPhoto(size: CGSize) {
        guard let asset = self.asset else {
            return
        }
        photoService.fetchOriginalImage(for: asset, size: size) { [weak self] image in
            guard let image = image else {
                return
            }
            self?.image = image
            self?.onSetImage?(image)
        }
    }
}
