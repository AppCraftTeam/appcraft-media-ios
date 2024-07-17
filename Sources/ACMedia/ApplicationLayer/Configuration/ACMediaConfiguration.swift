//
//  ACMediaConfiguration.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation

/// Basic picker configuration
public struct ACMediaConfiguration {
    
    /// Configurations for setting picker interface styles
    public var appearance: ACMediaAppearance
    
    /// Config for photo picker
    public var photoConfig: ACMediaPhotoPickerConfig
    
    /// Configurations for file picker
    public var documentsConfig: ACMediaDocumentConfig
    
    /// Initializes a new `ACMediaConfiguration` instance with the picker params.
    /// - Parameters:
    ///   - appearance: Configurations for setting picker interface styles
    ///   - photoConfig: Config for photo picker
    ///   - documentsConfig: Configurations for file picker
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
