//
//  CameraCellModel.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import UIKit

open class CameraCellModel {
    
    var configuration: ACMediaConfiguration
    
    var viewTapped: (() -> Void)?
    
    /// Create cell model
    /// - Parameter configuration: App config
    /// - Parameter viewTapped: tap callback
    init(configuration: ACMediaConfiguration, viewTapped: (() -> Void)?) {
        self.configuration = configuration
        self.viewTapped = viewTapped
    }
}
