//
//  ACMedia.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import UIKit

public class ACMedia: NSObject {
    
    // Callbacks
    public var assetsSelected: ((PhotoPickerCallbackModel) -> Void)?
    public var filesSelected: (([URL]) -> Void)?
    
    public var fileTypes: [PickerFilesType] = []
    
    public init(fileTypes: [PickerFilesType] = [], assetsSelected: ((PhotoPickerCallbackModel) -> Void)? = nil, filesSelected: (([URL]) -> Void)? = nil) {
        self.fileTypes = fileTypes
        self.assetsSelected = assetsSelected
        self.filesSelected = filesSelected
    }
    
    public func show(in parentVC: UIViewController) {
        let tabbarController = AppTabBarController()
        tabbarController.showPicker(in: parentVC, acMediaService: self)
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
