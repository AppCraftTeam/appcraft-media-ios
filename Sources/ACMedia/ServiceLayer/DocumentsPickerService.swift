//
//  DocumentsPickerService.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

public class DocumentsPickerService: NSObject {
    
    weak var parentVC: UIViewController?
    
    init(parentVC: UIViewController?) {
        self.parentVC = parentVC
    }
    
    
    /// Show picker for selecting documents
    /// - Parameter types: File types
    func showPicker(types: [ACMediaDocFileType]) {
        if #available(iOS 14.0, *) {
            let pickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: types.map({ $0.utType }), asCopy: true)
            pickerViewController.delegate = parentVC as? any UIDocumentPickerDelegate
            pickerViewController.allowsMultipleSelection = ACMediaConfig.documentsConfig.allowsMultipleSelection
            pickerViewController.shouldShowFileExtensions = ACMediaConfig.documentsConfig.shouldShowFileExtensions
            parentVC?.present(pickerViewController, animated: true, completion: nil)
        } else {
            let documentPicker = UIDocumentPickerViewController(documentTypes: types.map({ $0.kutType as String }), in: .import)
            documentPicker.delegate = parentVC as? any UIDocumentPickerDelegate
            documentPicker.allowsMultipleSelection = ACMediaConfig.documentsConfig.allowsMultipleSelection
            parentVC?.present(documentPicker, animated: true, completion: nil)
        }
    }
}
