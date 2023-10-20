//
//  AsyncImageLoader.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import PhotosUI
import UIKit

internal class AsyncImageLoader: Operation {
    
    var img: UIImage?
    var onFinishLoadingImage: ((_ image: UIImage?) -> Void)?
    
    private var photoAsset: PHAsset
    private var imageSize: CGSize
    
    override var isAsynchronous: Bool {
        return true
    }
    
    init(asset: PHAsset, imageSize: CGSize) {
        self.photoAsset = asset
        self.imageSize = imageSize
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        let photoManager = PhotoService()
        
        photoManager.fetchThumbnail(for: photoAsset, size: imageSize) { img in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self,
                      !strongSelf.isCancelled
                else {
                    return
                }
                strongSelf.img = img ?? UIImage()
                strongSelf.onFinishLoadingImage?(strongSelf.img)
            }
        }
    }
    
    public static func fetchImage(from asset: PHAsset, withSize size: CGSize) -> AsyncImageLoader? {
        AsyncImageLoader(asset: asset, imageSize: size)
    }
}
