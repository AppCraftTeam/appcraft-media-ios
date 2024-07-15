//
//  ACAsyncImageLoader.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import PhotosUI
import UIKit

open class ACAsyncImageLoader: Operation {
    
    var img: UIImage?
    var onFinishLoadingImage: ((_ image: UIImage?) -> Void)?
    
    private var photoAsset: PHAsset
    private var imageSize: CGSize
    
    open override var isAsynchronous: Bool {
        true
    }
    
    init(asset: PHAsset, imageSize: CGSize) {
        self.photoAsset = asset
        self.imageSize = imageSize
    }
    
    /// Performs the receiver’s non-concurrent task - fetch asset preview
    open override func main() {
        if isCancelled {
            return
        }
        
        let photoManager = ACPhotoService()
        
        photoManager.fetchThumbnail(for: photoAsset, size: imageSize) { img in
            DispatchQueue.main.async { [weak self] in
                guard let self,
                      !self.isCancelled else {
                    return
                }
                self.img = img ?? UIImage()
                self.onFinishLoadingImage?(self.img)
            }
        }
    }
    
    /// Run a task to get a preview of an asset
    /// - Parameters:
    ///   - asset: Asset
    ///   - size: Image size
    /// - Returns: asynced operation
    public static func fetchImage(from asset: PHAsset, withSize size: CGSize) -> ACAsyncImageLoader? {
        ACAsyncImageLoader(asset: asset, imageSize: size)
    }
}
