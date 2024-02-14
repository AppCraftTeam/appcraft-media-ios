//
//  AppTabBarControllerAdapter.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UITabBarDelegate
class AppTabBarControllerAdapter: NSObject, UITabBarControllerDelegate {
    
    var configuration: ACMediaConfiguration
    var types: [ACMediaDocFileType] = []
    weak var parentVC: UIViewController?
    
    init(configuration: ACMediaConfiguration, types: [ACMediaDocFileType], parentVC: UIViewController?) {
        self.configuration = configuration
        self.types = types
        self.parentVC = parentVC
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            let pickerService = DocumentsPickerService(configuration: configuration, parentVC: parentVC)
            pickerService.showPicker(types: types)
            return false
        }
        return true
    }
}
