//
//  ACMediaPhotoPickerConfig.swift
//  ACMedia-iOS
//
//  Created by Pavel Moslienko on 20.10.2023.
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation

public struct ACMediaPhotoPickerConfig {
    var types: [PhotoPickerFilesType]
    
    public var selectionLimit: Int {
        willSet {
            if newValue <= 0 {
                fatalError("Incorrect selection limit")
            }
        }
    }
    
    public var isSelectionRequired: Bool
    
    public init(
        types: [PhotoPickerFilesType] = PhotoPickerFilesType.allCases,
        selectionLimit: Int = 1,
        isSelectionRequired: Bool = false
    ) {
        self.types = types
        self.selectionLimit = selectionLimit
        self.isSelectionRequired = isSelectionRequired
    }
}
