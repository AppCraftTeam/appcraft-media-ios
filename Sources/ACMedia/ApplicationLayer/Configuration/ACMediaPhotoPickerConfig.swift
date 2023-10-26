//
//  ACMediaPhotoPickerConfig.swift
//  ACMedia-iOS
//
//  Created by Pavel Moslienko on 20.10.2023.
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation

public struct ACMediaPhotoPickerConfig {
    var fileTypes: [PickerFilesType] = PickerFilesType.allCases
    var types: [PhotoPickerFilesType] = PhotoPickerFilesType.allCases
    
    public var selectionLimit: Int = 1 {
        willSet {
            if newValue <= 0 {
                fatalError("Incorrect selection limit")
            }
        }
    }
    
    public var isSelectionRequired: Bool = false
}
