//
//  MainNavigationController.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit

public protocol PhotoPickerDelegate: AnyObject {
    func didSelect(images: [UIImage])
}

open class MainNavigationController: UINavigationController {
    
    // MARK: - Components
    private lazy var selectedCounterLabel: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        item.tintColor = .black
        item.isEnabled = false
        
        return item
    }()
    
    // MARK: - Params
    public weak var imageSelectorDelegate: PhotoPickerDelegate?
    
    private let navigationTransition = ZoomTransitionDelegate()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = navigationTransition
        
        setupToolbar()
        setupNavigationBar()
        
        let notificationHub = NotificationCenter.default
        notificationHub.addObserver(
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
        refreshToolbar()
    }
    
    @objc
    func refreshToolbar() {
        updateToolbarText()
    }
    
    func updateToolbarText() {
        let totalImages = SelectedImagesStack.shared.selectedCount
        let localizedCaption = String.locale(for: "SelectedCount")
        let displayedText = String(format: localizedCaption, totalImages)
        selectedCounterLabel.title = displayedText
    }
}
