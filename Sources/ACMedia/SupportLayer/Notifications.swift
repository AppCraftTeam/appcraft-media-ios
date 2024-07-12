//
//  Notifications.swift
//  ACMedia-iOS
//
//  Created by Pavel Moslienko on 20.10.2023.
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    ///Notification to track changes in the number of selected assets
    static var onSelectedImagesChanged = Notification.Name("ACMedia.onSelectedImagesChanged")
}
