//
//  ExampleType.swift
//  Example
//
//  Created by Pavel Moslienko on 12.07.2024.
//

import Foundation

enum ExampleType: CaseIterable {
    case singlePhoto, singleDoc, multiplePhotoAndDocs
    
    var title: String {
        switch self {
        case .singlePhoto:
            return "Single Photo"
        case .singleDoc:
            return "Single Document"
        case .multiplePhotoAndDocs:
            return "Multiple Photos and Documents"
        }
    }
    
    var subtitle: String {
        switch self {
        case .singlePhoto:
            return "Open picker for selecting 1 image"
        case .singleDoc:
            return  "Open files picker"
        case .multiplePhotoAndDocs:
            return "Open picker for multiple images or files"
        }
    }
}
