//
//  ACMediaPhotoDocConfig.swift
//  ACMedia-iOS
//
//  Created by Pavel Moslienko on 20.10.2023.
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation

public struct ACMediaPhotoDocConfig {
    public var fileFormats: [ACMediaDocFileType] = ACMediaDocFileType.allCases
    public var allowsMultipleSelection = false
    public var shouldShowFileExtensions = true
}
