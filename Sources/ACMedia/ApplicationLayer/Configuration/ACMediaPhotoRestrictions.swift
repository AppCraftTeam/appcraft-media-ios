//
//  ACMediaPhotoRestrictions.swift
//
//
//  Created by Pavel Moslienko on 11.07.2024.
//

import Foundation

/// Setting limits on the number of selected assets
public struct ACMediaPhotoRestrictions {
    /// The minimum number of selectable assets.
    public let min: Int
    
    /// The maximum number of selectable assets.
    public let max: Int?
    
    /// Preset restriction for selecting only one asset.
    public static let onlyOne: ACMediaPhotoRestrictions = ACMediaPhotoRestrictions(
        min: 1,
        max: 1
    )
    
    /// Factory method to create a restriction with a specified minimum and maximum.
    ///
    /// - Parameters:
    ///   - min: The minimum number of selectable assets.
    ///   - max: The maximum number of selectable assets.
    /// - Returns: A new instance of `ACMediaPhotoRestrictions`.
    public static func limit(min: Int, max: Int) -> ACMediaPhotoRestrictions {
        ACMediaPhotoRestrictions(
            min: min,
            max: max
        )
    }
    
    /// Initializes a new `ACMediaPhotoRestrictions` instance with the specified limits.
    ///
    /// - Parameters:
    ///   - min: The minimum number of selectable assets.
    ///   - max: The maximum number of selectable assets.
    public init(min: Int, max: Int?) {
        self.min = min <= 0 ? 1 : min
        
        if let max, max <= 0 {
            self.max = 1
        } else {
            self.max = max
        }
    }
}
