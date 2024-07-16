//
//  ACAlbumModel.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import PhotosUI
import UIKit

/// Data for the photo album
public struct ACAlbumModel {
    let title: String
    let count: Int
    let assets: PHFetchResult<PHAsset>
    var previewImage: UIImage?
    
    public init(title: String, assets: PHFetchResult<PHAsset>, previewImage: UIImage? = nil) {
        self.title = title
        self.count = assets.count
        self.assets = assets
        self.previewImage = previewImage
    }
}
