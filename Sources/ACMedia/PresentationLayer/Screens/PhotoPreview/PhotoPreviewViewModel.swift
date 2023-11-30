//
//  PhotoPreviewViewModel.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import Photos
import UIKit

class PhotoPreviewViewModel {
        
    // MARK: - Properties
    var image: UIImage?
    private var asset: PHAsset?
    private var photoService = PhotoService()
    
    // MARK: - Actions
    var onSetImage: ((_ image: UIImage) -> Void)?
    
    init(asset: PHAsset?) {
        self.asset = asset
    }
    
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
