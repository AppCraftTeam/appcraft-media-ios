//
//  String+Ext.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation

extension String {
    
    // Locale interface titles
    static func locale(for key: String) -> String {
        NSLocalizedString(key, bundle: Bundle.main, comment: "")
    }
}
