//
//  ACMedia.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import UIKit

public class ACMedia: UIViewController {
    
    public var fileTypes: [PickerFilesType] = [] {
        willSet {
            if newValue.isEmpty {
                fatalError("Filetypes cannot be empty")
            }
        }
    }
    
    // Callbacks
    public var assetsSelected: ((PhotoPickerCallbackModel) -> Void)?
    public var filesSelected: (([URL]) -> Void)?
    public var didOpenSettings: (() -> Void)?
    
    public init(fileTypes: [PickerFilesType] = [], assetsSelected: ((PhotoPickerCallbackModel) -> Void)? = nil, filesSelected: (([URL]) -> Void)? = nil) {
        self.fileTypes = fileTypes
        self.assetsSelected = assetsSelected
        self.filesSelected = filesSelected
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show(in parentVC: UIViewController) {
        let tabbarController = AppTabBarController()
        
        if self.fileTypes.count == 1 {
            switch self.fileTypes[0] {
            case .gallery:
                let vc = MainNavigationController(configuration: .shared, acMediaService: self)
                parentVC.present(vc, animated: true)
            case .files:
                let vc = DocumentsParentViewController()
                vc.didPickDocuments = { urls in
                    self.didPickDocuments(urls)
                }
                parentVC.present(vc, animated: true)
                
                
                let pickerService = DocumentsPickerService(parentVC: vc)
                pickerService.showPicker(types: ACMediaConfiguration.shared.documentsConfig.fileFormats)
            }
        } else {
            tabbarController.showPicker(in: parentVC, acMediaService: self)
        }
    }
}

public extension ACMedia {
    
    func didPickAssets(_ model: PhotoPickerCallbackModel) {
        self.assetsSelected?(model)
    }
    
    func didPickDocuments(_ urls: [URL]) {
        self.filesSelected?(urls)
    }
}

// MARK: - AppTabBarController
extension ACMedia: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        self.didPickDocuments(urls)
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {}
}
