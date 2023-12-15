//
//  ACMediaAppearance.swift
//  ACMedia-iOS
//
//  Created by Pavel Moslienko on 20.10.2023.
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import UIKit

public struct ACMediaAppearance {
    
    public var tintColor: UIColor
    public var backgroundColor: UIColor
    public var foregroundColor: UIColor
    public var checkmarkForegroundColor: UIColor
    public var cellsInRow: Int {
        didSet {
            if cellsInRow <= 0 {
                cellsInRow = 3
            }
        }
    }
    public var gridSpacing: CGFloat {
        didSet {
            if gridSpacing < 0 {
                gridSpacing = 0
            }
        }
    }
    public var previewCardCornerRadius: CGFloat {
        didSet {
            if previewCardCornerRadius < 0 {
                previewCardCornerRadius = 0
            }
        }
    }
    public var navBarTitleFont: UIFont
    public var emptyAlbumFont: UIFont
    public var cancelTitleFont: UIFont
    public var doneTitleFont: UIFont
    public var toolbarFont: UIFont
    public var allowsPhotoPreviewZoom: Bool
    
    public init(
        tintColor: UIColor = ACMediaTheme.tintColor,
        backgroundColor: UIColor = ACMediaTheme.backgroundColor,
        foregroundColor: UIColor = ACMediaTheme.foregroundColor,
        checkmarkForegroundColor: UIColor = ACMediaTheme.checkmarkForegroundColor,
        cellsInRow: Int = 3,
        gridSpacing: CGFloat = 5,
        previewCardCornerRadius: CGFloat = 0.0,
        navBarTitleFont: UIFont = .systemFont(ofSize: 17.0, weight: .regular),
        emptyAlbumFont: UIFont = .systemFont(ofSize: 22, weight: .bold),
        cancelTitleFont: UIFont = .systemFont(ofSize: 17.0, weight: .regular),
        doneTitleFont: UIFont = .systemFont(ofSize: 17.0, weight: .semibold),
        toolbarFont: UIFont = .systemFont(ofSize: 17.0, weight: .regular),
        allowsPhotoPreviewZoom: Bool = true
    ) {
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.checkmarkForegroundColor = checkmarkForegroundColor
        self.cellsInRow = cellsInRow
        self.gridSpacing = gridSpacing
        self.previewCardCornerRadius = previewCardCornerRadius
        self.navBarTitleFont = navBarTitleFont
        self.emptyAlbumFont = emptyAlbumFont
        self.cancelTitleFont = cancelTitleFont
        self.doneTitleFont = doneTitleFont
        self.toolbarFont = toolbarFont
        self.allowsPhotoPreviewZoom = allowsPhotoPreviewZoom
    }
}
