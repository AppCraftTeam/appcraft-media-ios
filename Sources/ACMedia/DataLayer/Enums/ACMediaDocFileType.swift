//
//  ACMediaDocFileType.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

public enum ACMediaDocFileType {
    #warning("todo add formats")
    case png, jpeg, gif, bmp, text, pdf, zip
    
    var kutType: CFString {
        switch self {
        case .png:
            return kUTTypePNG
        case .jpeg:
            return kUTTypeJPEG
        case .gif:
            return kUTTypeGIF
        case .bmp:
            return kUTTypeBMP
        case .text:
            return kUTTypeText
        case .pdf:
            return kUTTypePDF
        case .zip:
            return kUTTypeZipArchive
        }
    }
    
    @available(iOSApplicationExtension 14.0, *)
    var utType: UTType {
        switch self {
        case .png:
            return .png
        case .jpeg:
            return .jpeg
        case .gif:
            return .gif
        case .bmp:
            return .bmp
        case .text:
            return .text
        case .pdf:
            return .pdf
        case .zip:
            return .zip
        }
    }
}
