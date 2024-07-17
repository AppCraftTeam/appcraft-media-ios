//
//  ACMediaDocFileType.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

/// File types (extension) to be selected in the document picker
public enum ACMediaDocFileType: CaseIterable {
    
    case png, jpeg, gif, bmp, text, pdf, zip, docx, xlsx, mp3, mp4, csv, json
    
    /// For iOS < 14.0
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
        case .docx:
            return "org.openxmlformats.wordprocessingml.document" as CFString
        case .xlsx:
            return "org.openxmlformats.spreadsheetml.sheet" as CFString
        case .mp3:
            return kUTTypeMP3
        case .mp4:
            return kUTTypeMPEG4
        case .csv:
            return kUTTypeCommaSeparatedText
        case .json:
            return kUTTypeJSON
        }
    }
    
    @available(iOS 14.0, *)
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
        case .docx:
            return UTType(exportedAs: "org.openxmlformats.wordprocessingml.document")
        case .xlsx:
            return UTType(exportedAs: "org.openxmlformats.spreadsheetml.sheet")
        case .mp3:
            return .mp3
        case .mp4:
            return .mpeg4Movie
        case .csv:
            return .commaSeparatedText
        case .json:
            return .json
        }
    }
}
