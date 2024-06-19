//
//  ACMediaViewController.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import UIKit

public class ACMediaViewController {
    
    public var configuration: ACMediaConfiguration
    public var fileType: ACPickerFilesType
    // Callbacks
    public var assetsSelected: ((ACPickerCallbackModel) -> Void)?
    public var filesSelected: (([URL]) -> Void)?
    public var didOpenSettings: (() -> Void)?
    
    public init(configuration: ACMediaConfiguration, fileType: ACPickerFilesType, assetsSelected: ((ACPickerCallbackModel) -> Void)? = nil, filesSelected: (([URL]) -> Void)? = nil) {
        self.configuration = configuration
        self.fileType = fileType
        self.assetsSelected = assetsSelected
        self.filesSelected = filesSelected
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Present picker controller
    /// - Parameter parentVC: parent view controller
    public func show(in parentVC: UIViewController) {
        let tabbarController = ACTabBarController(acMediaService: self, configuration: configuration)
        
        switch fileType {
        case .gallery:
            let vc = ACMainNavigationController(configuration: configuration, acMediaService: self)
            parentVC.present(vc, animated: true)
        case .files, .galleryAndFiles:
            #warning("todo + gallery")
            tabbarController.showPicker(in: parentVC, acMediaService: self)
        }
    }
}

public extension ACMediaViewController {
    
    func didPickAssets(_ model: ACPickerCallbackModel) {
        self.assetsSelected?(model)
    }
    
    func didPickDocuments(_ urls: [URL]) {
        self.filesSelected?(urls)
    }
}
