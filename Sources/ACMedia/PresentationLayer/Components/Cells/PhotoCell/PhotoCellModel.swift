//
//  PhotoCellModel.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import UIKit

open class PhotoCellModel {
    
    var image: UIImage?
    var index: Int
    var isSelected: Bool
    var configuration: ACMediaConfiguration
    var viewTapped: (() -> Void)?
    var viewSelectedToggle: (() -> Void)?
    
    /// Create cell model
    /// - Parameters:
    ///   - image: Photo image
    ///   - index: position (row) in collection view
    ///   - isSelected: selected status
    ///   - configuration: App config
    ///   - viewTapped: tap callback
    ///   - viewSelectedToggle: changing selection callback
    init(image: UIImage?, index: Int, isSelected: Bool, configuration: ACMediaConfiguration, viewTapped: (() -> Void)?, viewSelectedToggle: (() -> Void)?) {
        self.image = image
        self.index = index
        self.isSelected = isSelected
        self.configuration = configuration
        self.viewTapped = viewTapped
        self.viewSelectedToggle = viewSelectedToggle
    }
}
