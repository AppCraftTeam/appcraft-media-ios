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
        willSet {
            if newValue < 0 {
                fatalError("Incorrecr cells count")
            }
        }
    }
    public var gridSpacing: CGFloat {
        willSet {
            if newValue < 0 {
                fatalError("Incorrecr grid spacing")
            }
        }
    }
    public var allowsPhotoPreviewZoom: Bool = true
    
    public init(
        tintColor: UIColor = ACMediaTheme.tintColor,
        backgroundColor: UIColor = ACMediaTheme.backgroundColor,
        foregroundColor: UIColor = ACMediaTheme.foregroundColor,
        checkmarkForegroundColor: UIColor = ACMediaTheme.checkmarkForegroundColor,
        cellsInRow: Int = 3,
        gridSpacing: CGFloat = 5,
        allowsPhotoPreviewZoom: Bool = true
    ) {
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.checkmarkForegroundColor = checkmarkForegroundColor
        self.cellsInRow = cellsInRow
        self.gridSpacing = gridSpacing
        self.allowsPhotoPreviewZoom = allowsPhotoPreviewZoom
    }
}
