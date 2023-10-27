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
        
        return item
    }()
    
    // MARK: - Params    
    private let navigationTransition = ZoomTransitionDelegate()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = navigationTransition
        
        setupToolbar()
        setupNavigationBar()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshToolbar),
            name: .onSelectedImagesChanged,
            object: nil)
        
        let imageGridController = PhotoGridViewController()
        viewControllers = [imageGridController]
    }
    
    public required init(configuration: ACMediaConfiguration) {
        SelectedImagesStack.shared.deleteAll()
        ACMediaConfiguration.shared = configuration
        super.init(nibName: nil, bundle: nil)
    }
    
    public convenience init() {
        self.init(configuration: ACMediaConfiguration.shared)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MainNavigationController {
    
    func setupNavigationBar() {
        navigationBar.tintColor = ACMediaConfiguration.shared.appearance.tintColor
    }
    
    func setupToolbar() {
        let barItems: [UIBarButtonItem] = [
            .init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            selectedCounterLabel,
            .init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
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
    
    func updateToolbarText() {
        let totalImages = SelectedImagesStack.shared.selectedCount
        let localizedCaption = AppLocale.selectedCount.locale
        let displayedText = String(format: localizedCaption, totalImages)
        selectedCounterLabel.title = displayedText
    }
}
