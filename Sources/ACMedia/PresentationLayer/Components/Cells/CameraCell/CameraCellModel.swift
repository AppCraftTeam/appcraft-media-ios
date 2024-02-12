//
//  CameraCellModel.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import UIKit

public class CameraCellModel {
    
    var viewTapped: (() -> Void)?
    
    /// Create cell model
    /// - Parameter viewTapped: tap callback
    init(viewTapped: (() -> Void)?) {
        self.viewTapped = viewTapped
    }
}
