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
    /// The supported media types for the photo picker.
    var types: [ACPhotoPickerFilesType]
    
    /// The selection limits for the photo picker.
    public var limiter: ACMediaPhotoRestrictions
    
    /// A boolean value that determines whether camera usage is allowed.
    public var allowCamera: Bool
    
    /// A boolean value that determines whether to display min/max restrictions.
    public var displayMinMaxRestrictions: Bool
    
    /// Initializes a new `ACMediaPhotoPickerConfig` instance with the specified settings.
    ///
    /// - Parameters:
    ///   - types: The supported media types for the photo picker.
    ///   - limiter: The selection limits for the photo picker.
    ///   - allowCamera: A boolean value that determines whether camera usage is allowed.
    ///   - displayMinMaxRestrictions: A boolean value that determines whether to display min/max restrictions.
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
