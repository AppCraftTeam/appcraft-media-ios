//
//  ACMediaLayout.swift
//  ACMedia-iOS
//
//  Created by Pavel Moslienko on 20.06.2024.
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit

/// Photo grid settings for the photo picker
public struct ACMediaLayout {
    public var phonePortraitCells: Int
    public var phoneLandscapeCells: Int
    public var padPortraitCells: Int
    public var padLandscapeCells: Int
    
    public var gridSpacing: CGFloat
    public var previewCardCornerRadius: CGFloat
    
    public var cellsInRow: Int {
        switch (UIDevice.current.userInterfaceIdiom, UIDevice.current.orientation) {
        case (.phone, .portrait), (.phone, .portraitUpsideDown):
            return phonePortraitCells
        case (.phone, .landscapeLeft), (.phone, .landscapeRight):
            return phoneLandscapeCells
        case (.pad, .portrait), (.pad, .portraitUpsideDown):
            return padPortraitCells
        case (.pad, .landscapeLeft), (.pad, .landscapeRight):
            return padLandscapeCells
        default:
            return phonePortraitCells
        }
    }
    
    public init(
        phonePortraitCells: Int = 3,
        phoneLandscapeCells: Int = 5,
        padPortraitCells: Int = 5,
        padLandscapeCells: Int = 7,
        gridSpacing: CGFloat = 5,
        previewCardCornerRadius: CGFloat = 0.0
    ) {
        self.phonePortraitCells = max(phonePortraitCells, 1)
        self.phoneLandscapeCells = max(phoneLandscapeCells, 1)
        self.padPortraitCells = max(padPortraitCells, 1)
        self.padLandscapeCells = max(padLandscapeCells, 1)
        self.gridSpacing = max(gridSpacing, 0)
        self.previewCardCornerRadius = max(previewCardCornerRadius, 0)
    }
}

