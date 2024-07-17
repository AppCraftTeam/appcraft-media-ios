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
    /// The title of the album.
    let title: String
    
    /// The number of assets in the album.
    let count: Int
    
    /// The fetched result containing the assets of the album.
    let assets: PHFetchResult<PHAsset>
    
    /// Preview image for the album.
    var previewImage: UIImage?
    
    /// Initializes a new `ACAlbumModel` instance with the specified title, assets, and optional preview image.
    ///
    /// - Parameters:
    ///   - title: The title of the album.
    ///   - assets: The fetched result containing the assets of the album.
    ///   - previewImage: Preview image for the album. Defaults to `nil`.
    public init(title: String, assets: PHFetchResult<PHAsset>, previewImage: UIImage? = nil) {
        self.title = title
        self.count = assets.count
        self.assets = assets
        self.previewImage = previewImage
    }
}
