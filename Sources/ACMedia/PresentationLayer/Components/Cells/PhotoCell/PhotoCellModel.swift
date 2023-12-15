//
//  PhotoCellModel.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import UIKit

public class PhotoCellModel {
    
    var image: UIImage?
    var index: Int
    var isSelected: Bool
    var viewTapped: (() -> Void)?
    var viewSelectedToggle: (() -> Void)?

    init(image: UIImage?, index: Int, isSelected: Bool, viewTapped: (() -> Void)?, viewSelectedToggle: (() -> Void)?) {
        self.image = image
        self.index = index
        self.isSelected = isSelected
        self.viewTapped = viewTapped
        self.viewSelectedToggle = viewSelectedToggle
    }
}
