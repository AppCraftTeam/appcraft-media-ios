//
//  ACMediaPhotoRestrictions.swift
//
//
//  Created by Pavel Moslienko on 11.07.2024.
//

import Foundation

/// Setting limits on the number of selected assets
public struct ACMediaPhotoRestrictions {
    
    public let min: Int
    public let max: Int?
    
    public static let onlyOne: ACMediaPhotoRestrictions = ACMediaPhotoRestrictions(
        min: 1,
        max: 1
    )
    
    public static func limit(min: Int, max: Int) -> ACMediaPhotoRestrictions {
        ACMediaPhotoRestrictions(
            min: min,
            max: max
        )
    }
    
    public init(min: Int, max: Int?) {
        self.min = min <= 0 ? 1 : min
        
        if let max, max <= 0 {
            self.max = 1
        } else {
            self.max = max
        }
    }
}
