//
//  ACPhotoPickerFilesType.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Photos

/// Selecting the file type for the gallery picker
public enum ACPhotoPickerFilesType: CaseIterable {
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
