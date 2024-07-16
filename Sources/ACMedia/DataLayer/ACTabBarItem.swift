//
//  ACTabBarItem.swift
//
//
//  Created by Pavel Moslienko on 11.07.2024.
//

import UIKit

/// Elements for tab bar picker
enum ACTabBarItem {
    case gallery, file
    
    var item: UITabBarItem {
        switch self {
        case .gallery:
            let tabBarItem = UITabBarItem(
                title: ACAppLocale.gallery.locale,
                image: ACAppAssets.Navigation.gallery.image?.withRenderingMode(.alwaysTemplate),
                selectedImage: ACAppAssets.Navigation.gallery.image?.withRenderingMode(.alwaysTemplate)
            )
            tabBarItem.tag = 0
            return tabBarItem
        case .file:
            let tabBarItem = UITabBarItem(
                title: ACAppLocale.file.locale,
                image: ACAppAssets.Navigation.file.image?.withRenderingMode(.alwaysTemplate),
                selectedImage: ACAppAssets.Navigation.file.image?.withRenderingMode(.alwaysTemplate)
            )
            tabBarItem.tag = 1
            return tabBarItem
        }
    }
}
