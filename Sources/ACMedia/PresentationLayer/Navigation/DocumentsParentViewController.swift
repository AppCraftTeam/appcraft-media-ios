//
//  DocumentsParentViewController.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import UIKit

// Just wrapper to UIDocumentPickerDelegate work, because in this case UIDocumentPickerViewController presented vc and delegate must me same
class DocumentsParentViewController: UIViewController, UIDocumentPickerDelegate {
    
    var didPickDocuments: (([URL]) -> Void)?
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        self.didPickDocuments?(urls)
        self.dismiss(animated: true)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.dismiss(animated: true)
    }
}
