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

    init(viewTapped: (() -> Void)?) {
        self.viewTapped = viewTapped
    }
}
