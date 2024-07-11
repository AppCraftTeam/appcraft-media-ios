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
    
    public var fileType: ACPickerFilesType
    public var selectedAssetsStack: ACSelectedImagesStack
    
    
    open var configuration: ACMediaConfiguration
    open var photoViewController: ACPhotoPickerViewControllerInterface
    open var documentsViewController: ACDocumentPickerViewControllerInterface
    
    // Callbacks
    public var assetsSelected: ((ACPickerCallbackModel) -> Void)?
    public var filesSelected: (([URL]) -> Void)?
    public var didOpenSettings: (() -> Void)?
    
    @available(iOS 13.0, *)
    var tabBarAppearance: UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        return appearance
    }
    
    public required init(
        configuration: ACMediaConfiguration,
        fileType: ACPickerFilesType,
        photoViewController: ACPhotoPickerViewControllerInterface? = nil,
        documentsViewController: ACDocumentPickerViewControllerInterface? = nil,
        assetsSelected: ((ACPickerCallbackModel) -> Void)? = nil,
        filesSelected: (([URL]) -> Void)? = nil,
        didOpenSettings: (() -> Void)? = nil
    ) {
        self.configuration = configuration
        self.fileType = fileType
        self.selectedAssetsStack = ACSelectedImagesStack()
        self.assetsSelected = assetsSelected
        self.filesSelected = filesSelected
        self.didOpenSettings = didOpenSettings
        
        self.photoViewController = photoViewController ?? ACMainNavigationController(
            configuration: configuration,
            selectedAssetsStack: selectedAssetsStack
        )
        self.documentsViewController = documentsViewController ?? ACDocumentPickerViewController.create(configuration: configuration)
        super.init(nibName: nil, bundle: nil)

        if photoViewController == nil {
            self.photoViewController.didPickAssets = { assets in
                self.assetsSelected?(assets)
            }
            self.photoViewController.didOpenSettings = {
                self.didOpenSettings?()
            }
        }
        
        if documentsViewController == nil {
            self.documentsViewController.didPickDocuments = { [weak self] urls in
                self?.filesSelected?(urls)
            }
        }
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
        
        switch fileType {
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
        switch fileType {
        case .gallery:
            return [
                photoViewController
            ]
        case .files:
            return [
                documentsViewController
            ]
        case .galleryAndFiles:
            return [
                photoViewController,
                documentsViewController
            ]
        }
    }
}
