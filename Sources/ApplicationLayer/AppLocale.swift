//
//  AppLocale.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation

enum AppLocale: String {
    
    static private let key = "ACMedia."
    
    case done = "done"
    case cancel = "cancel"
    case gallery = "gallery"
    case file = "file"
    case emptyAlbum = "emptyAlbumLabel"
    case assetsPermissionTitle = "permissionRequired"
    case assetsPermissionMessage = "permissionRequiredDescription"
    case assetsPermissionOpenSettings = "settings"
    case selectedCount = "selectedCount"
    case requireSelect = "require"
    case selected = "selected"
    
    var locale: String {
        String.locale(for: AppLocale.key + self.rawValue)
    }
}
