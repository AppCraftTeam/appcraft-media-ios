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
    /// The number of photo cells to display in portrait orientation on a iPhone.
    public var phonePortraitCells: Int
    
    /// The number of photo cells to display in landscape orientation on a iPhone.
    public var phoneLandscapeCells: Int
    
    /// The number of photo cells to display in portrait orientation on a iPad.
    public var padPortraitCells: Int
    
    /// The number of photo cells to display in landscape orientation on a iPad.
    public var padLandscapeCells: Int
    
    /// The spacing between photo cells in the grid.
    public var gridSpacing: CGFloat
    
    /// The corner radius for preview image cards.
    public var previewCardCornerRadius: CGFloat
    
    /// Computes the number of photo cells to display in a row
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
    
    /// Initializes a new `ACMediaLayout` instance with the specified layout settings.
    /// - Parameters:
    ///   - phonePortraitCells: The number of photo cells to display in portrait orientation on a iPhone.
    ///   - phoneLandscapeCells: The number of photo cells to display in landscape orientation on a iPhone.
    ///   - padPortraitCells: The number of photo cells to display in portrait orientation on a iPad.
    ///   - padLandscapeCells: The number of cphoto ells to display in landscape orientation on a iPad.
    ///   - gridSpacing: The spacing between photo cells in the grid.
    ///   - previewCardCornerRadius: The corner radius for preview image cards.
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
