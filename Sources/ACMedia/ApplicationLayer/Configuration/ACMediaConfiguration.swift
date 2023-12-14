//
//  ACMediaConfiguration.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation

public var ACMediaConfig: ACMediaConfiguration {
    ACMediaConfiguration.shared
}

public struct ACMediaConfiguration {
    
    internal init(
        appearance: ACMediaAppearance = ACMediaAppearance(),
        photoConfig: ACMediaPhotoPickerConfig = ACMediaPhotoPickerConfig(),
        documentsConfig: ACMediaPhotoDocConfig = ACMediaPhotoDocConfig()
    ) {
        self.appearance = appearance
        self.photoConfig = photoConfig
        self.documentsConfig = documentsConfig
    }
    
    public static var shared: ACMediaConfiguration = ACMediaConfiguration()
    
    public init() {}
    
    public var appearance = ACMediaAppearance()
    public var photoConfig = ACMediaPhotoPickerConfig()
    public var documentsConfig = ACMediaPhotoDocConfig()
}
