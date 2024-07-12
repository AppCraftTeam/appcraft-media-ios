//
//  ACTabNavigationController.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit

public protocol ACPhotoPickerViewControllerInterface: UIViewController {
    var didPickAssets: ((ACPickerCallbackModel) -> Void)? { get set }
    var didOpenSettings: (() -> Void)? { get set }
}

public protocol ACDocumentPickerViewControllerInterface: UIViewController {
    var didPickDocuments: (([URL]) -> Void)? { get set }
}

open class ACTabBarController: UITabBarController {
    
    open var configuration: ACMediaConfiguration
    open var photoViewController: ACPhotoPickerViewControllerInterface?
    open var documentsViewController: ACDocumentPickerViewControllerInterface?

    @available(iOS 13.0, *)
    var tabBarAppearance: UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        return appearance
    }
        
    public required init(
        configuration: ACMediaConfiguration,
        photoViewController: ACPhotoPickerViewControllerInterface?,
        documentsViewController: ACDocumentPickerViewControllerInterface?
    ) {
        self.configuration = configuration
        self.photoViewController = photoViewController
        self.documentsViewController = documentsViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init(
        configuration: ACMediaConfiguration,
        photoViewController: ACPhotoPickerViewControllerInterface
    ) {
        self.configuration = configuration
        self.photoViewController = photoViewController
        self.documentsViewController = nil
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init(
        configuration: ACMediaConfiguration,
        documentsViewController: ACDocumentPickerViewControllerInterface
    ) {
        self.configuration = configuration
        self.photoViewController = nil
        self.documentsViewController = documentsViewController
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
        selectedIndex = 0
        tabBar.setNeedsDisplay()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - Private
private extension ACTabBarController {
    
    func setupViewControllers() {
        photoViewController?.tabBarItem = ACTabBarItem.gallery.item
        documentsViewController?.tabBarItem = ACTabBarItem.file.item
        
        let navControllers = makeNavControllers()
        setViewControllers(navControllers, animated: true)
    }
    
    func configureTabBar() {
        tabBar.tintColor = configuration.appearance.colors.tintColor
        tabBar.barStyle = .default
        tabBar.isTranslucent = true
        
        if (self.viewControllers ?? []).count < 2 {
            tabBar.isHidden = true
            tabBar.removeFromSuperview()
            
            edgesForExtendedLayout = []
            extendedLayoutIncludesOpaqueBars = true
            view.backgroundColor = .white
        }

        let items = tabBar.items ?? []
        items.forEach({ item in
            if #available(iOS 13.0, *) {
                item.standardAppearance = tabBarAppearance
            }
        })
    }
    
    func makeNavControllers() -> [UIViewController] {
        var controllers: [UIViewController] = []
        if let photoViewController = photoViewController {
            controllers.append(photoViewController)
        }
        if let documentsViewController = documentsViewController {
            controllers.append(documentsViewController)
        }
        return controllers
    }
}
