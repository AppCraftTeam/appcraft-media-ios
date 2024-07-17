//
//  ACAppAssets.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit

private protocol Asset {
    var image: UIImage? { get }
}

/// Icons used in the pickers interface
public enum ACAppAssets {
    
    /// Icons for tabbar
    enum Navigation: Asset {
        case gallery, file
        
        var image: UIImage? {
            switch self {
            case .gallery:
                if #available(iOS 13.0, *) {
                    return UIImage(systemName: "photo.stack")
                }
                return UIImage(named: "gallery")
            case .file:
                if #available(iOS 13.0, *) {
                    return UIImage(systemName: "folder")
                }
                return UIImage(named: "file")
            }
        }
    }
    
    /// Icons for cells
    enum Icon: Asset {
        case downArrow, checkmarkEmpty, checkmarkFilled, camera
        
        var image: UIImage? {
            switch self {
            case .downArrow:
                /// For selecting album
                return UIImage(named: "down-arrow")
            case .checkmarkEmpty:
                /// For photo cell
                if #available(iOS 13.0, *) {
                    return UIImage(systemName: "circle")
                }
                return UIImage(named: "circle")
            case .checkmarkFilled:
                /// For photo cell
                if #available(iOS 13.0, *) {
                    return UIImage(systemName: "checkmark.circle")
                }
                return UIImage(named: "check")
            case .camera:
                // For camera cell
                if #available(iOS 13.0, *) {
                    return UIImage(systemName: "circle.square")
                }
                return UIImage(named: "camera")
            }
        }
    }
}
