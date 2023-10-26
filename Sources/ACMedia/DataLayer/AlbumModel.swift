//
//  AlbumModel.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import PhotosUI
import UIKit

internal struct AlbumModel {
    let title: String
    let count: Int
    let assets: PHFetchResult<PHAsset>
    var previewImage: UIImage?
    
    internal init(title: String, assets: PHFetchResult<PHAsset>, previewImage: UIImage? = nil) {
        self.title = title
        self.count = assets.count
        self.assets = assets
        self.previewImage = previewImage
    }
}
