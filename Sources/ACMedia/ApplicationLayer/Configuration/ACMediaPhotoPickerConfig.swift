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
    var types: [ACPhotoPickerFilesType]
    
    public var minimimSelection: Int = 1 {
        didSet {
            if minimimSelection <= 0 {
                minimimSelection = 1
            }
        }
    }
    
    public var maximumSelection: Int? {
        didSet {
            if let val = maximumSelection, val <= 0 {
                maximumSelection = 1
            }
        }
    }
    
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
