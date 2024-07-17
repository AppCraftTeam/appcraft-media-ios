//
//  ACMediaFonts.swift
//  ACMedia-iOS
//
//  Created by Pavel Moslienko on 20.06.2024.
//  Copyright © 2024 AppCraft. All rights reserved.
//

import UIKit

/// Font settings for labels displayed in the interface
public struct ACMediaFonts {
    /// The font used for navigation bar title.
    public var navBarTitleFont: UIFont
    
    /// The font used for empty album messages.
    public var emptyAlbumFont: UIFont
    
    /// The font used for cancel button.
    public var cancelTitleFont: UIFont
    
    /// The font used for done button.
    public var doneTitleFont: UIFont
    
    /// The font used for toolbar items.
    public var toolbarFont: UIFont
    
    /// Initializes a new `ACMediaFonts` instance with the specified font settings.
    /// - Parameters:
    ///   - navBarTitleFont: The font used for navigation bar title.
    ///   - emptyAlbumFont: The font used for empty album messages.
    ///   - cancelTitleFont: The font used for cancel button.
    ///   - doneTitleFont: The font used for done button.
    ///   - toolbarFont: The font used for toolbar items.
    public init(
        navBarTitleFont: UIFont = .systemFont(ofSize: 17.0, weight: .regular),
        emptyAlbumFont: UIFont = .systemFont(ofSize: 22, weight: .bold),
        cancelTitleFont: UIFont = .systemFont(ofSize: 17.0, weight: .regular),
        doneTitleFont: UIFont = .systemFont(ofSize: 17.0, weight: .semibold),
        toolbarFont: UIFont = .systemFont(ofSize: 17.0, weight: .semibold)
    ) {
        self.navBarTitleFont = navBarTitleFont
        self.emptyAlbumFont = emptyAlbumFont
        self.cancelTitleFont = cancelTitleFont
        self.doneTitleFont = doneTitleFont
        self.toolbarFont = toolbarFont
    }
}

