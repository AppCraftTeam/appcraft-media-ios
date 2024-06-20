//
//  ACMediaService.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import UIKit

public class ACMediaService {
    
    public var configuration: ACMediaConfiguration
    public var fileType: ACPickerFilesType
    
    public var selectedAssetsStack: ACSelectedImagesStack
    
    // Callbacks
    public var assetsSelected: ((ACPickerCallbackModel) -> Void)?
    public var filesSelected: (([URL]) -> Void)?
    public var didOpenSettings: (() -> Void)?
    
    public init(configuration: ACMediaConfiguration, fileType: ACPickerFilesType, assetsSelected: ((ACPickerCallbackModel) -> Void)? = nil, filesSelected: (([URL]) -> Void)? = nil) {
        self.configuration = configuration
        self.fileType = fileType
        self.selectedAssetsStack = ACSelectedImagesStack()
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
        tabbarController.showPicker(in: parentVC, acMediaService: self)
    }
}

public extension ACMediaService {
    
    func didPickAssets(_ model: ACPickerCallbackModel) {
        self.assetsSelected?(model)
    }
    
    func didPickDocuments(_ urls: [URL]) {
        self.filesSelected?(urls)
    }
}
