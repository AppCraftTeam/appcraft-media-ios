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
    
    public var tintColor: UIColor = AppTheme.tintColor
    public var backgroundColor: UIColor = AppTheme.backgroundColor
    public var foregroundColor: UIColor = AppTheme.foregroundColor
    public var checkmarkForegroundColor: UIColor = AppTheme.checkmarkForegroundColor
    public var cellsInRow: Int = 3 {
        willSet {
            if newValue < 0 {
                fatalError("Incorrecr cells count")
            }
        }
    }
    public var gridSpacing: CGFloat = 5 {
        willSet {
            if newValue < 0 {
                fatalError("Incorrecr grid spacing")
            }
        }
    }
    public var allowsPhotoPreviewZoom: Bool = true
}
