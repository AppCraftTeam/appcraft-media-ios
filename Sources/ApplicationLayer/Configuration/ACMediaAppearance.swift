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
    
    public var tintColor: UIColor = .red
    public var foregroundColor: UIColor = .black
    public var checkmarkForegroundColor: UIColor = .systemBlue
    public var checkmarkBackgroundColor: UIColor = .white
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
