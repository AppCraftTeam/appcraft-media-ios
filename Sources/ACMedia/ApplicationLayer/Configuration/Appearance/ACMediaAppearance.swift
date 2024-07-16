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
    public var colors: ACMediaColors
    public var layout: ACMediaLayout
    public var fonts: ACMediaFonts
    public var allowsPhotoPreviewZoom: Bool
    
    public init(
        colors: ACMediaColors = ACMediaColors(),
        layout: ACMediaLayout = ACMediaLayout(),
        fonts: ACMediaFonts = ACMediaFonts(),
        allowsPhotoPreviewZoom: Bool = true
    ) {
        self.colors = colors
        self.layout = layout
        self.fonts = fonts
        self.allowsPhotoPreviewZoom = allowsPhotoPreviewZoom
    }
}
