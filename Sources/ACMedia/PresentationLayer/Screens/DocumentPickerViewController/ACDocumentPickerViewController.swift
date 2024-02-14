//
//  ACDocumentPickerViewController.swift
//  
//
//  Created by Pavel Moslienko on 13.02.2024.
//

import UIKit

class ACDocumentPickerViewController: UIViewController, UIDocumentPickerDelegate {
    
    var didPickDocuments: (([URL]) -> Void)?
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("vvvv - ddddddvbfg didPickDocuments \(didPickDocuments)")
        self.didPickDocuments?(urls)
        self.dismiss(animated: true)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("vvvv 1111")
        self.dismiss(animated: true)
    }
}
