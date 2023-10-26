//
//  AppTabNavigationController.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit

enum AppTabBarItem {
    case gallery, file
    
    var item: UITabBarItem {
        switch self {
        case .gallery:
            #warning("todo locale")
            let tabBarItem = UITabBarItem(title: AppLocale.gallery.locale,
                                          image: AppAssets.Navigation.gallery.image?.withRenderingMode(.alwaysTemplate),
                                          selectedImage: AppAssets.Navigation.gallery.image?.withRenderingMode(.alwaysTemplate)
            )
            tabBarItem.tag = 0
            return tabBarItem
        case .file:
            let tabBarItem = UITabBarItem(title: AppLocale.file.locale,
                                          image: AppAssets.Navigation.file.image?.withRenderingMode(.alwaysTemplate),
                                          selectedImage: AppAssets.Navigation.file.image?.withRenderingMode(.alwaysTemplate)
            )
            tabBarItem.tag = 1
            return tabBarItem
        }
    }
}

open class AppTabBarController: UITabBarController {
    
    private let adapter = AppTabBarControllerAdapter()
    
    private(set) lazy var photoController: UINavigationController = {
        let vc = MainNavigationController(configuration: .shared)
        vc.tabBarItem = AppTabBarItem.gallery.item
        return vc
    }()
    
    private(set) lazy var documentsViewController: UIViewController = {
        let vc = UIViewController()
        vc.tabBarItem = AppTabBarItem.file.item
        
        return vc
    }()
    
    @available(iOSApplicationExtension 13.0, *)
    var tabBarAppearance: UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        return appearance
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupViewControllers()
        configureTabBar()
        setAttributes()
        selectedIndex = 0
        tabBar.setNeedsDisplay()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    open func showPicker(in parent: UIViewController, fileFormats: [ACMediaDocFileType] = []) {
        self.adapter.parent = parent as? DocumentsPickerDelegate
        self.adapter.types = fileFormats
        self.adapter.parentVC = self
        (self.photoController as? MainNavigationController)?.imageSelectorDelegate = parent as? PhotoPickerDelegate
        
        parent.present(self, animated: true)
    }
}

// MARK: - Private
private extension AppTabBarController {
    
    func setAttributes() {}
    
    func setupViewControllers() {
        let navControllers = makeNavControllers()
        setViewControllers(navControllers, animated: true)
    }
    
    func configureTabBar() {
        tabBar.tintColor = ACMediaConfig.appearance.tintColor
        tabBar.barStyle = .default
        tabBar.isTranslucent = true
        self.delegate = adapter
        
        let items = tabBar.items ?? []
        print("configureTabBar \(items)")
        items.enumerated().forEach({ (index, item) in
            if #available(iOSApplicationExtension 13.0, *) {
                item.standardAppearance = tabBarAppearance
            }
        })
    }
    
    func makeNavControllers() -> [UINavigationController] {
        [
            photoController,
            UINavigationController(rootViewController: documentsViewController),
        ]
    }
}

// MARK: - AppTabBarController
extension AppTabBarController: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("onPickDocuments delllll \(self.adapter.parent)")
        self.adapter.parent?.onPickDocuments(urls)
        self.dismiss(animated: true)
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("documentPickerWasCancelled...")
    }
}
