//
//  ACTabNavigationController.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit

public protocol ACDocumentPickerViewControllerInterface: UIViewController {
    var didPickDocuments: (([URL]) -> Void)? { get set }
}

open class ACTabBarController: UITabBarController {
    
    public var fileType: ACPickerFilesType
    public var selectedAssetsStack: ACSelectedImagesStack
    
    // Callbacks
    public var assetsSelected: ((ACPickerCallbackModel) -> Void)?
    public var filesSelected: (([URL]) -> Void)?
    public var didOpenSettings: (() -> Void)?
    
    open var configuration: ACMediaConfiguration
    
    private(set) lazy var photoController: ACMainNavigationController = {
        let vc = ACMainNavigationController(
            configuration: configuration,
            selectedAssetsStack: selectedAssetsStack,
            didPickAssets: { assets in
                self.assetsSelected?(assets)
            },
            didOpenSettings: {
                self.didOpenSettings?()
            }
        )
        vc.tabBarItem = ACTabBarItem.gallery.item
        return vc
    }()
    
    open var documentsViewController: ACDocumentPickerViewControllerInterface {
        defaultDocumentsViewController
    }
    
    private var defaultDocumentsViewController: ACDocumentPickerViewControllerInterface {
        let vc = ACDocumentPickerViewController.create(configuration: configuration)
        vc.didPickDocuments = { [weak self] urls in
            self?.filesSelected?(urls)
        }
        vc.tabBarItem = ACTabBarItem.file.item
        
        return vc
    }
    
    @available(iOS 13.0, *)
    var tabBarAppearance: UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        return appearance
    }
    
    public required init(
        configuration: ACMediaConfiguration,
        fileType: ACPickerFilesType,
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
