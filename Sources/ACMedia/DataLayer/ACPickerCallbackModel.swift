//
//  ACPickerCallbackModel.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import UIKit

/// A model for returning media files selected in the picker to the application
public struct ACPickerCallbackModel {
    public var images: [UIImage]
    public var videoUrls: [URL]
}
