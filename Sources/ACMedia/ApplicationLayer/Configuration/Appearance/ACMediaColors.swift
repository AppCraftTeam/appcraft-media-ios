//
//  ACMediaColors.swift
//  ACMedia-iOS
//
//  Created by Pavel Moslienko on 20.06.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import UIKit

/// Color settings for UI elements
public struct ACMediaColors {
    /// The tint color for UI elements.
    public var tintColor: UIColor
    
    /// The background color for UI elements.
    public var backgroundColor: UIColor
    
    /// The foreground color for UI elements.
    public var foregroundColor: UIColor
    
    /// The color for the photo selecting checkmark.
    public var checkmarkForegroundColor: UIColor
    
    /// Initializes a new `ACMediaColors` instance with the specified color settings.
    ///
    /// - Parameters:
    ///   - tintColor: The tint color for UI elements.
    ///   - backgroundColor: The background color for UI elements.
    ///   - foregroundColor: The foreground color for UI elements.
    ///   - checkmarkForegroundColor: The color for the photo selecting checkmark.
    public init(
        tintColor: UIColor = ACMediaTheme.tintColor,
        backgroundColor: UIColor = ACMediaTheme.backgroundColor,
        foregroundColor: UIColor = ACMediaTheme.foregroundColor,
        checkmarkForegroundColor: UIColor = ACMediaTheme.checkmarkForegroundColor
    ) {
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.checkmarkForegroundColor = checkmarkForegroundColor
    }
}
