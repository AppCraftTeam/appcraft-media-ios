//
//  ACMediaPhotoDocConfig.swift
//  ACMedia-iOS
//
//  Created by Pavel Moslienko on 20.10.2023.
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation

/// Configurations for file picker
public struct ACMediaDocumentConfig {
    public var fileFormats: [ACMediaDocFileType]
    public var allowsMultipleSelection: Bool
    public var shouldShowFileExtensions: Bool
    
    public init(
        fileFormats: [ACMediaDocFileType] = ACMediaDocFileType.allCases,
        allowsMultipleSelection: Bool = false,
        shouldShowFileExtensions: Bool = true
    ) {
        self.fileFormats = fileFormats
        self.allowsMultipleSelection = allowsMultipleSelection
        self.shouldShowFileExtensions = shouldShowFileExtensions
    }
}
