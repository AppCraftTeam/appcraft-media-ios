//
//  MainNavigationController.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit

open class MainNavigationController: UINavigationController {
    
    // MARK: - Components
    private lazy var selectedCounterLabel: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        item.tintColor = ACMediaConfiguration.shared.appearance.foregroundColor
        item.setTitleTextAttributes([.font: ACMediaConfiguration.shared.appearance.toolbarFont], for: [])
        
        return item
    }()
    
    // MARK: - Params
    public var acMediaService: ACMediaViewController?
    private let navigationTransition = ZoomTransitionDelegate()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = navigationTransition
        
        setupToolbar()
        setupNavigationBar()
        
        // Subscribe to notification to track changes in the count of selected assets
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshToolbar),
            name: .onSelectedImagesChanged,
            object: nil)
        
        let imageGridController = PhotoGridViewController()
        viewControllers = [imageGridController]
    }
    
    public required init(configuration: ACMediaConfiguration, acMediaService: ACMediaViewController?) {
        self.acMediaService = acMediaService
        SelectedImagesStack.shared.deleteAll()
        ACMediaConfiguration.shared = configuration
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MainNavigationController {
    
    func setupNavigationBar() {
        navigationBar.tintColor = ACMediaConfiguration.shared.appearance.tintColor
        
        if #available(iOS 13.0, *) {
            let style = UINavigationBarAppearance()
            style.buttonAppearance.normal.titleTextAttributes = [.font: ACMediaConfiguration.shared.appearance.cancelTitleFont]
            style.doneButtonAppearance.normal.titleTextAttributes = [.font: ACMediaConfiguration.shared.appearance.doneTitleFont]
            
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
        self.toolbar.tintColor = ACMediaConfiguration.shared.appearance.tintColor
        self.toolbar.barStyle = .default
        self.toolbar.isTranslucent = true
        self.toolbar.backgroundColor = ACMediaConfiguration.shared.appearance.backgroundColor
        self.toolbar.isUserInteractionEnabled = false
        refreshToolbar()
    }
    
    @objc
    func refreshToolbar() {
        updateToolbarText()
    }
    
    /// Update the text in the toolbar to show the current number of selected assets
    func updateToolbarText() {
        let totalImages = SelectedImagesStack.shared.selectedCount
        let selectedStr = String(format: ACAppLocale.selectedCount.locale, totalImages)
        var displayedText: String {
            guard ACMediaConfig.photoConfig.displayMinMaxRestrictions else {
                return selectedStr
            }
            var additionalStr: [String] = []
            let min = ACMediaConfig.photoConfig.minimimSelection
            if min > 1 {
                additionalStr += [String(format: ACAppLocale.selectedMin.locale, min)]
            }
            if let max = ACMediaConfig.photoConfig.maximumSelection {
                additionalStr += [String(format: ACAppLocale.selectedMax.locale, max)]
            }
            return selectedStr + ", " + additionalStr.joined(separator: ", ")
        }
        selectedCounterLabel.title = displayedText
    }
}
