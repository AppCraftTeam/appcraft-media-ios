//
//  ACDocumentPickerViewController.swift
//
//
//  Created by Pavel Moslienko on 13.02.2024.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

public class ACDocumentPickerViewController: UIDocumentPickerViewController, UIDocumentPickerDelegate {
    
    public var didPickDocuments: (([URL]) -> Void)?
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        self.didPickDocuments?(urls)
        self.dismiss(animated: true)
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("vvvv 1111")
        self.dismiss(animated: true)
    }
    
    /// Show picker for selecting documents
    /// - Parameter types: File types
    static func create(types: [ACMediaDocFileType], configuration: ACMediaConfiguration) -> ACDocumentPickerViewController {
        if #available(iOS 14.0, *) {
            let pickerViewController = ACDocumentPickerViewController(forOpeningContentTypes: types.map({ $0.utType }), asCopy: true)
            pickerViewController.delegate = pickerViewController
            pickerViewController.allowsMultipleSelection = configuration.documentsConfig.allowsMultipleSelection
            pickerViewController.shouldShowFileExtensions = configuration.documentsConfig.shouldShowFileExtensions
            
            return pickerViewController
        } else {
            let pickerViewController = ACDocumentPickerViewController(documentTypes: types.map({ $0.kutType as String }), in: .import)
            pickerViewController.delegate = pickerViewController
            pickerViewController.allowsMultipleSelection = configuration.documentsConfig.allowsMultipleSelection
            
            return pickerViewController
        }
    }
}
