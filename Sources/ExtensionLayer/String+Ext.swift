//
//  String+Ext.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation

public extension String {
    
    static func locale(for key: String) -> String {
        return Bundle.local.localizedString(forKey: key, value: "", table: "ACMedia")
    }
}
