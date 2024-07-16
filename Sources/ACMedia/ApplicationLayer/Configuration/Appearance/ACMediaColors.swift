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
    public var tintColor: UIColor
    public var backgroundColor: UIColor
    public var foregroundColor: UIColor
    public var checkmarkForegroundColor: UIColor
    
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
