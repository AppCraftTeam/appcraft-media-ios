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
    
    var types: [ACMediaDocFileType] = []
    weak var parent: DocumentsPickerDelegate?
    weak var parentVC: UIViewController?
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            #warning("todo refactoring")
            let pickerService = DocumentsPickerService()
            pickerService.delegate = parent
            pickerService.parentVC = parentVC
            pickerService.showPicker(types: types)
            return false
        }
        return true
    }
}
