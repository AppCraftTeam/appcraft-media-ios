//
//  ACMediaConfiguration.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation

public struct ACMediaConfiguration {
    
    public var appearance: ACMediaAppearance
    public var photoConfig: ACMediaPhotoPickerConfig
    public var documentsConfig: ACMediaDocumentConfig
    
    public init(
        appearance: ACMediaAppearance = ACMediaAppearance(),
        photoConfig: ACMediaPhotoPickerConfig = ACMediaPhotoPickerConfig(),
        documentsConfig: ACMediaDocumentConfig = ACMediaDocumentConfig()
    ) {
        self.appearance = appearance
        self.photoConfig = photoConfig
        self.documentsConfig = documentsConfig
    }
}
