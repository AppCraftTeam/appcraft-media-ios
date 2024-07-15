//
//  MainNavigationController.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit

open class ACPhotoNavigationController: UINavigationController, ACPhotoPickerViewControllerInterface {    
    
    // MARK: - Components
    private lazy var selectedCounterLabel: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        item.tintColor = configuration.appearance.colors.foregroundColor
        item.setTitleTextAttributes([.font: configuration.appearance.fonts.toolbarFont], for: [])
        
        return item
    }()
    
    // MARK: - Params
    public var didPickAssets: ((ACPickerCallbackModel) -> Void)?
    public var didOpenSettings: (() -> Void)?
    
    open var configuration: ACMediaConfiguration
    public var selectedAssetsStack: ACSelectedImagesStack
    private let navigationTransition: ACZoomTransitionDelegate
    
    public required init(
        configuration: ACMediaConfiguration,
        didPickAssets: ((ACPickerCallbackModel) -> Void)? = nil,
        didOpenSettings: (() -> Void)? = nil
    ) {
        self.configuration = configuration
        self.didPickAssets = didPickAssets
        self.didOpenSettings = didOpenSettings
        self.navigationTransition = ACZoomTransitionDelegate(configuration: configuration)
        self.selectedAssetsStack = ACSelectedImagesStack()
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = navigationTransition
        
        setupToolbar()
        setupNavigationBar()
        
        // Track changes in the count of selected assets
        self.selectedAssetsStack.didSelectedImagesChanged = { [weak self] in
            self?.updateToolbarText()
        }
        
        let imageGridController = ACPhotoGridViewController(
            viewModel: ACPhotosViewModel(
                configuration: configuration,
                selectedAssetsStack: selectedAssetsStack,
                didPickAssets: { selectedAssetsModel in
                    self.didPickAssets?(selectedAssetsModel)
                }, didOpenSettings: {
                    self.didOpenSettings?()
                }
            )
        )
        
        viewControllers = [imageGridController]
    }
}

private extension ACPhotoNavigationController {
    
    func setupNavigationBar() {
        navigationBar.tintColor = configuration.appearance.colors.tintColor
        
        if #available(iOS 13.0, *) {
            let style = UINavigationBarAppearance()
            style.buttonAppearance.normal.titleTextAttributes = [.font: configuration.appearance.fonts.cancelTitleFont]
            style.doneButtonAppearance.normal.titleTextAttributes = [.font: configuration.appearance.fonts.doneTitleFont]
            
            navigationBar.standardAppearance = style
            navigationBar.scrollEdgeAppearance = style
            navigationBar.compactAppearance = style
        }
    }
    
    func setupToolbar() {
        let barItems: [UIBarButtonItem] = [
            .init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            selectedCounterLabel,
            .init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ]
        
        self.toolbarItems = barItems
        self.toolbar.tintColor = configuration.appearance.colors.tintColor
        self.toolbar.barStyle = .default
        self.toolbar.isTranslucent = true
        self.toolbar.backgroundColor = configuration.appearance.colors.backgroundColor
        self.toolbar.isUserInteractionEnabled = false
        updateToolbarText()
    }
    
    /// Update the text in the toolbar to show the current number of selected assets
    func updateToolbarText() {
        let totalImages = selectedAssetsStack.selectedCount
        let selectedStr = String(format: ACAppLocale.selectedCount.locale, totalImages)
        var displayedText: String {
            guard configuration.photoConfig.displayMinMaxRestrictions else {
                return selectedStr
            }
            var additionalStr: [String] = []
            let min = configuration.photoConfig.limiter.min
            if min > 1 {
                additionalStr += [String(format: ACAppLocale.selectedMin.locale, min)]
            }
            if let max = configuration.photoConfig.limiter.max {
                additionalStr += [String(format: ACAppLocale.selectedMax.locale, max)]
            }
            return selectedStr + ", " + additionalStr.joined(separator: ", ")
        }
        selectedCounterLabel.title = displayedText
    }
}
