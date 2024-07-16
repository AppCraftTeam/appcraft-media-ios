//
//  ACMediaPhotoPickerConfig.swift
//  ACMedia-iOS
//
//  Created by Pavel Moslienko on 20.10.2023.
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation

/// Config for photo picker
public struct ACMediaPhotoPickerConfig {
    var types: [ACPhotoPickerFilesType]
    
    public var limiter: ACMediaPhotoRestrictions
    
    public var allowCamera: Bool
    public var displayMinMaxRestrictions: Bool
    
    public init(
        types: [ACPhotoPickerFilesType] = ACPhotoPickerFilesType.allCases,
        limiter: ACMediaPhotoRestrictions = .onlyOne,
        allowCamera: Bool = true,
        displayMinMaxRestrictions: Bool = false
    ) {
        self.types = types
        self.allowCamera = allowCamera
        self.limiter = limiter
        self.displayMinMaxRestrictions = displayMinMaxRestrictions
    }
}
