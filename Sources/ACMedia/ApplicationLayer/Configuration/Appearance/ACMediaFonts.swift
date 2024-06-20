//
//  ACMediaFonts.swift
//  
//
//  Created by Pavel Moslienko on 20.06.2024.
//

import UIKit

public struct ACMediaFonts {
    public var navBarTitleFont: UIFont
    public var emptyAlbumFont: UIFont
    public var cancelTitleFont: UIFont
    public var doneTitleFont: UIFont
    public var toolbarFont: UIFont

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

