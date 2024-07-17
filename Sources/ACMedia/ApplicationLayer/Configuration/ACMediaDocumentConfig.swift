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
    /// The supported file formats.
    public var fileFormats: [ACMediaDocFileType]
    
    /// A boolean value that determines whether multiple selection is allowed.
    public var allowsMultipleSelection: Bool
    
    /// A boolean value that determines whether to show file extensions.
    public var shouldShowFileExtensions: Bool
    
    /// Initializes a new `ACMediaDocumentConfig` instance with the specified settings.
    ///
    /// - Parameters:
    ///   - fileFormats: The supported file formats.
    ///   - allowsMultipleSelection: A boolean value that determines whether multiple selection is allowed.
    ///   - shouldShowFileExtensions: A boolean value that determines whether to show file extensions.
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
