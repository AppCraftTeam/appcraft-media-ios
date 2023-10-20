//
//  AppAssets.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit

private protocol Asset {
    var image: UIImage? { get }
}

public enum AppAssets {
    
    enum Navigation: Asset {
        case gallery, file
        
        var image: UIImage? {
            switch self {
            case .gallery:
                if #available(iOSApplicationExtension 13.0, *) {
                    return UIImage(systemName: "photo.stack")
                }
                return UIImage(named: "gallery")
            case .file:
                if #available(iOSApplicationExtension 13.0, *) {
                    return UIImage(systemName: "folder")
                }
                return UIImage(named: "file")
            }
        }
    }
    
    enum Icon: Asset {
        case downArrow, checkmarkEmpty, checkmarkFilled, camera
        
        var image: UIImage? {
            switch self {
            case .downArrow:
                if #available(iOSApplicationExtension 13.0, *) {
                    return UIImage(systemName: "chevron.down")
                }
                return UIImage(named: "down-arrow")
            case .checkmarkEmpty:
                if #available(iOSApplicationExtension 13.0, *) {
                    return UIImage(systemName: "circle")
                }
                return UIImage(named: "circle")
            case .checkmarkFilled:
                if #available(iOSApplicationExtension 13.0, *) {
                    return UIImage(systemName: "checkmark.circle")
                }
                return UIImage(named: "check")
            case .camera:
                if #available(iOSApplicationExtension 13.0, *) {
                    return UIImage(systemName: "circle.square")
                }
                return UIImage(named: "camera")
            }
        }
    }
}
