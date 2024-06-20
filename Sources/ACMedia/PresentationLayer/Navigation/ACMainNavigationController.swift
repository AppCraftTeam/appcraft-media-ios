//
//  MainNavigationController.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit

open class ACMainNavigationController: UINavigationController {
    
    // MARK: - Components
    private lazy var selectedCounterLabel: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        item.tintColor = configuration.appearance.foregroundColor
        item.setTitleTextAttributes([.font: configuration.appearance.toolbarFont], for: [])
        
        return item
    }()
    
    // MARK: - Params
    open var acMediaService: ACMediaViewController?
    open var configuration: ACMediaConfiguration
    private let navigationTransition: ACZoomTransitionDelegate
    
    public required init(configuration: ACMediaConfiguration, acMediaService: ACMediaViewController?) {
        self.acMediaService = acMediaService
        self.configuration = configuration
        self.navigationTransition = ACZoomTransitionDelegate(configuration: configuration)
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        guard let acMediaService = self.acMediaService else {
            return
        }
        self.delegate = navigationTransition
        
        setupToolbar()
        setupNavigationBar()
        
        // Subscribe to notification to track changes in the count of selected assets
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshToolbar),
            name: .onSelectedImagesChanged,
            object: nil)
        
        let imageGridController = ACPhotoGridViewController(
            viewModel: ACPhotosViewModel(
                configuration: configuration,
                selectedAssetsStack: acMediaService.selectedAssetsStack,
                didPickAssets: { selectedAssetsModel in
                    self.acMediaService?.didPickAssets(selectedAssetsModel)
                }, didOpenSettings: {
                    self.acMediaService?.didOpenSettings?()
                }
            )
        )
        viewControllers = [imageGridController]
    }
}

private extension ACMainNavigationController {
    
    func setupNavigationBar() {
        navigationBar.tintColor = configuration.appearance.tintColor
        
        if #available(iOS 13.0, *) {
            let style = UINavigationBarAppearance()
            style.buttonAppearance.normal.titleTextAttributes = [.font: configuration.appearance.cancelTitleFont]
            style.doneButtonAppearance.normal.titleTextAttributes = [.font: configuration.appearance.doneTitleFont]
            
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
        self.toolbar.tintColor = configuration.appearance.tintColor
        self.toolbar.barStyle = .default
        self.toolbar.isTranslucent = true
        self.toolbar.backgroundColor = configuration.appearance.backgroundColor
        self.toolbar.isUserInteractionEnabled = false
        refreshToolbar()
    }
    
    @objc
    func refreshToolbar() {
        updateToolbarText()
    }
    
    /// Update the text in the toolbar to show the current number of selected assets
    func updateToolbarText() {
        guard let totalImages = self.acMediaService?.selectedAssetsStack.selectedCount else {
            return
        }
        let selectedStr = String(format: ACAppLocale.selectedCount.locale, totalImages)
        var displayedText: String {
            guard configuration.photoConfig.displayMinMaxRestrictions else {
                return selectedStr
            }
            var additionalStr: [String] = []
            let min = configuration.photoConfig.minimimSelection
            if min > 1 {
                additionalStr += [String(format: ACAppLocale.selectedMin.locale, min)]
            }
            if let max = configuration.photoConfig.maximumSelection {
                additionalStr += [String(format: ACAppLocale.selectedMax.locale, max)]
            }
            return selectedStr + ", " + additionalStr.joined(separator: ", ")
        }
        selectedCounterLabel.title = displayedText
    }
}
