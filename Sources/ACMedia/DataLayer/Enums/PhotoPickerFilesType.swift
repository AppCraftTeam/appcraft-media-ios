//
//  PhotoPickerFilesType.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Photos

public enum PhotoPickerFilesType: CaseIterable {
    case photo
    case video
    
    var mediaType: PHAssetMediaType {        
        switch self {
        case .photo:
            return PHAssetMediaType.image
        case .video:
            return PHAssetMediaType.video
        }
    }
}
