//
//  ACTabNavigationController.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit

/// Protocol for the image picker screen
public protocol ACPhotoPickerViewControllerInterface: UIViewController {
    /// Passing selected assets from the picker to the application
    var didPickAssets: ((ACPickerCallbackModel) -> Void)? { get set }
    /// Processing to open system settings where it is possible to manually give permission to access the photo
    var didOpenSettings: (() -> Void)? { get set }
}

/// Protocol for the document picker screen
public protocol ACDocumentPickerViewControllerInterface: UIViewController {
    /// Passing selected files from the picker to the application
    var didPickDocuments: (([URL]) -> Void)? { get set }
}

/// UITabBarController with the gallery picker and file picker displayed in the tabs of the screen
open class ACTabBarController: UITabBarController {
    
    /// The configuration settings for the media picker
    open var configuration: ACMediaConfiguration
    
    /// Photo (video) picker view controller
    open var photoViewController: ACPhotoPickerViewControllerInterface
    
    /// File picker view controller
    open var documentsViewController: ACDocumentPickerViewControllerInterface

    @available(iOS 13.0, *)
    var tabBarAppearance: UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        return appearance
    }
    
    /**
     Initializes a new instance of the media picker tab view controller with the specified configuration and view controllers.
     - Parameters:
     - configuration: The configuration settings for the media picker.
     - photoViewController: The view controller that handles photo picking.
     - documentsViewController: The view controller that handles document picking.
     */
    public required init(
        configuration: ACMediaConfiguration,
        photoViewController: ACPhotoPickerViewControllerInterface,
        documentsViewController: ACDocumentPickerViewControllerInterface
    ) {
        self.configuration = configuration
        self.photoViewController = photoViewController
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
        photoViewController.tabBarItem = ACTabBarItem.gallery.item
        documentsViewController.tabBarItem = ACTabBarItem.file.item
        
        let navControllers = makeNavControllers()
        setViewControllers(navControllers, animated: true)
    }
    
    func configureTabBar() {
        tabBar.tintColor = configuration.appearance.colors.tintColor
        tabBar.barStyle = .default
        tabBar.isTranslucent = true

        let items = tabBar.items ?? []
        items.forEach({ item in
            if #available(iOS 13.0, *) {
                item.standardAppearance = tabBarAppearance
            }
        })
    }
    
    func makeNavControllers() -> [UIViewController] {
        [photoViewController, documentsViewController]
    }
}
