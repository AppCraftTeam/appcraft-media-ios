//
//  AppTheme.swift
//  ACMedia-iOS
//
//  Created by Pavel Moslienko on 26.10.2023.
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit

enum AppTheme {
    
    static var backgroundColor: UIColor {
        if #available(iOSApplicationExtension 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
    
    static var tintColor: UIColor {
        if #available(iOSApplicationExtension 13.0, *) {
            return .systemBlue
        } else {
            return .blue
        }
    }
    
    static var foregroundColor: UIColor {
        if #available(iOSApplicationExtension 13.0, *) {
            return .label
        } else {
            return .black
        }
    }
    
    static var checkmarkForegroundColor: UIColor {
        if #available(iOSApplicationExtension 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
}
