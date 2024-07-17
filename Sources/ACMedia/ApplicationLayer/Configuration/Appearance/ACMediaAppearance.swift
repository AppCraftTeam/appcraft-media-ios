//
//  ACMediaAppearance.swift
//  ACMedia-iOS
//
//  Created by Pavel Moslienko on 20.10.2023.
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit

/// Configurations for setting picker interface styles
public struct ACMediaAppearance {
    
    /// Color settings for UI elements
    public var colors: ACMediaColors
    
    /// Photo grid settings for the photo picker
    public var layout: ACMediaLayout
    
    /// Font settings for labels displayed in the interface
    public var fonts: ACMediaFonts
    
    /// Initializes a new `ACMediaAppearance` instance with the appearance settings.
    /// - Parameters:
    ///   - colors: Color settings for UI elements
    ///   - layout: Photo grid settings for the photo picker
    ///   - fonts: Font settings for labels displayed in the interface
    public init(
        colors: ACMediaColors = ACMediaColors(),
        layout: ACMediaLayout = ACMediaLayout(),
        fonts: ACMediaFonts = ACMediaFonts()
    ) {
        self.colors = colors
        self.layout = layout
        self.fonts = fonts
    }
}
