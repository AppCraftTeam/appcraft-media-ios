//
//  ACDocumentPickerViewController.swift
//
//
//  Created by Pavel Moslienko on 13.02.2024.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

open class ACDocumentPickerViewController: UIDocumentPickerViewController, ACDocumentPickerViewControllerInterface, UIDocumentPickerDelegate {
    
    open var didPickDocuments: (([URL]) -> Void)?
    
    open func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        self.didPickDocuments?(urls)
        self.dismiss(animated: true)
    }
    
    open func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.dismiss(animated: true)
    }
    
    /// Show picker for selecting documents
    /// - Parameter types: File types
    static func create(configuration: ACMediaConfiguration) -> ACDocumentPickerViewController {
        let types = configuration.documentsConfig.fileFormats
        if #available(iOS 14.0, *) {
            let pickerViewController = ACDocumentPickerViewController(forOpeningContentTypes: types.map({ $0.utType }), asCopy: true)
            pickerViewController.delegate = pickerViewController
            pickerViewController.allowsMultipleSelection = configuration.documentsConfig.allowsMultipleSelection
            pickerViewController.shouldShowFileExtensions = configuration.documentsConfig.shouldShowFileExtensions
            pickerViewController.view.tintColor = configuration.appearance.colors.tintColor

            return pickerViewController
        } else {
            let pickerViewController = ACDocumentPickerViewController(documentTypes: types.map({ $0.kutType as String }), in: .import)
            pickerViewController.delegate = pickerViewController
            pickerViewController.allowsMultipleSelection = configuration.documentsConfig.allowsMultipleSelection
            pickerViewController.view.tintColor = configuration.appearance.colors.tintColor

            return pickerViewController
        }
    }
}
