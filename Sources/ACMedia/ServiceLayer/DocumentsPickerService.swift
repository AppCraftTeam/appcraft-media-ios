//
//  DocumentsPickerService.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

public protocol DocumentsPickerDelegate: AnyObject {
    func onPickDocuments(_ urls: [URL])
}

public class DocumentsPickerService: NSObject {
    
    weak var parentVC: UIViewController?
    
    func showPicker(types: [ACMediaDocFileType]) {
        if #available(iOSApplicationExtension 14.0, *) {
            let pickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: types.map({ $0.utType }), asCopy: true)
            pickerViewController.delegate = parentVC as? UIDocumentPickerDelegate
            pickerViewController.allowsMultipleSelection = ACMediaConfig.documentsConfig.allowsMultipleSelection
            pickerViewController.shouldShowFileExtensions = ACMediaConfig.documentsConfig.shouldShowFileExtensions
            parentVC?.present(pickerViewController, animated: true, completion: nil)
        } else {
            let documentPicker = UIDocumentPickerViewController(documentTypes: types.map({ $0.kutType as String }), in: .import)
            documentPicker.delegate = parentVC as? UIDocumentPickerDelegate
            documentPicker.allowsMultipleSelection = ACMediaConfig.documentsConfig.allowsMultipleSelection
            parentVC?.present(documentPicker, animated: true, completion: nil)
        }
    }
}
