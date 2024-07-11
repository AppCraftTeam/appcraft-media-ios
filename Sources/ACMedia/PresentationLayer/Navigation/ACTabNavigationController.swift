//
//  ACTabNavigationController.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit

open class ACTabBarController: UITabBarController {
    
    private var acMediaService: ACMediaService
    open var configuration: ACMediaConfiguration
    
    private(set) lazy var photoController: ACMainNavigationController = {
        let vc = ACMainNavigationController(configuration: configuration, acMediaService: acMediaService)
        vc.tabBarItem = ACTabBarItem.gallery.item
        return vc
    }()
    
    private(set) lazy var documentsViewController: UIViewController = {
        let vc = ACDocumentPickerViewController.create(configuration: configuration)
        vc.didPickDocuments = { [weak self] urls in
            self?.acMediaService.didPickDocuments(urls)
        }
        vc.tabBarItem = ACTabBarItem.file.item
        
        return vc
    }()
    
    @available(iOS 13.0, *)
    var tabBarAppearance: UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        return appearance
    }
    
    public required init(acMediaService: ACMediaService, configuration: ACMediaConfiguration) {
        self.acMediaService = acMediaService
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    open func showPicker(in parent: UIViewController, acMediaService: ACMediaService) {
        self.photoController.acMediaService = acMediaService
        self.acMediaService = acMediaService

        parent.present(self, animated: true)
    }
}

// MARK: - Private
private extension ACTabBarController {
    
    func setAttributes() {}
    
    func setupViewControllers() {
        let navControllers = makeNavControllers()
        setViewControllers(navControllers, animated: true)
    }
    
    func configureTabBar() {
        tabBar.tintColor = configuration.appearance.colors.tintColor
        tabBar.barStyle = .default
        tabBar.isTranslucent = true
        
        switch acMediaService.fileType {
        case .gallery, .files:
            tabBar.isHidden = true
            tabBar.removeFromSuperview()
            
            edgesForExtendedLayout = []
            extendedLayoutIncludesOpaqueBars = true
            view.backgroundColor = .white
        case .galleryAndFiles:
            break
        }
                
        let items = tabBar.items ?? []
        items.forEach({ item in
            if #available(iOS 13.0, *) {
                item.standardAppearance = tabBarAppearance
            }
        })
    }
    
    func makeNavControllers() -> [UIViewController] {
        switch acMediaService.fileType {
        case .gallery:
            return [
                photoController
            ]
        case .files:
            return [
                documentsViewController
            ]
        case .galleryAndFiles:
            return [
                photoController,
                documentsViewController
            ]
        }
    }
}
