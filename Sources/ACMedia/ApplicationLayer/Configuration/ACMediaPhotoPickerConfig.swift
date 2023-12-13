//
//  ACMediaPhotoPickerConfig.swift
//  ACMedia-iOS
//
//  Created by Pavel Moslienko on 20.10.2023.
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation

public enum ACMediaPhotoRestrictions {
    case onlyOne, limit(min: Int, max: Int)
}

public struct ACMediaPhotoPickerConfig {
    var types: [PhotoPickerFilesType]
    
    public var minimimSelection: Int = 1 {
        willSet {
            if newValue <= 0 {
                fatalError("Incorrect minimim selection limit")
            }
        }
    }
    
    public var maximumSelection: Int? {
        willSet {
            if let val = newValue, val <= 0 {
                fatalError("Incorrect maximum selection limit")
            }
        }
    }
    
    public var allowCamera: Bool
    public var displayMinMaxRestrictions: Bool
    
    public init(
        types: [PhotoPickerFilesType] = PhotoPickerFilesType.allCases,
        limiter: ACMediaPhotoRestrictions = .onlyOne,
        allowCamera: Bool = true,
        displayMinMaxRestrictions: Bool = false
    ) {
        self.types = types
        self.allowCamera = allowCamera
        switch limiter {
        case .onlyOne:
            self.minimimSelection = 1
            self.maximumSelection = 1
        case let .limit(min, max):
            self.minimimSelection = min
            self.maximumSelection = max
        }
        self.displayMinMaxRestrictions = displayMinMaxRestrictions
    }
}
