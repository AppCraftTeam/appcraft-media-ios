//
//  ACMediaLayout.swift
//  
//
//  Created by Pavel Moslienko on 20.06.2024.
//

import UIKit

public struct ACMediaLayout {
    public var cellsInRow: Int
    public var gridSpacing: CGFloat
    public var previewCardCornerRadius: CGFloat

    public init(
        cellsInRow: Int = 3,
        gridSpacing: CGFloat = 5,
        previewCardCornerRadius: CGFloat = 0.0
    ) {
        self.cellsInRow = cellsInRow
        self.gridSpacing = max(gridSpacing, 0)
        self.previewCardCornerRadius = max(previewCardCornerRadius, 0)
    }
}

