//
//  ACMediaTheme.swift
//  ACMedia-iOS
//
//  Created by Pavel Moslienko on 26.10.2023.
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit

/// Standard colors for decorating the picker interface
public enum ACMediaTheme {
    
    public static var backgroundColor: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
    
    public static var tintColor: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBlue
        } else {
            return .blue
        }
    }
    
    public static var foregroundColor: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
    }
    
    public static var checkmarkForegroundColor: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
}
