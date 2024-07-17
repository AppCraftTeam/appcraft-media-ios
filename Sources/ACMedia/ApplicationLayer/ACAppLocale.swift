//
//  ACAppLocale.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation

/// Keys for localization of interface elements
enum ACAppLocale: String {
    
    static private let key = "ACMedia."
    
    case done = "done"
    case back = "back"
    case cancel = "cancel"
    case gallery = "gallery"
    case file = "file"
    case emptyAlbum = "emptyAlbumLabel"
    case assetsPermissionTitle = "permissionRequired"
    case assetsPermissionMessage = "permissionRequiredDescription"
    case assetsPermissionOpenSettings = "settings"
    case selectedCount = "selectedCount"
    case selectedMin = "selectedMin"
    case selectedMax = "selectedMax"
    case requireSelect = "require"
    case selected = "selected"
    
    var locale: String {
        String.locale(for: ACAppLocale.key + self.rawValue)
    }
}
