//
//  PhotoPreviewViewController.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import PhotosUI
import UIKit

open class PhotoPreviewViewController: UIViewController {
    
    var viewModel: PhotoPreviewViewModel
    
    // MARK: - Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public required init(viewModel: PhotoPreviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewModel.configuration.appearance.backgroundColor
        
        viewModel.onSetImage = { [weak self] image in
            self?.setupImage(image)
        }
        
        reloadData()
    }
    
    func reloadData() {
        setupComponents()
        viewModel.loadPhoto(size: imageView.frame.size)
    }
}

// MARK: - Setup
private extension PhotoPreviewViewController {
    
    func setupComponents() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
                
        setupNavbar()
    }
    
    func setupImage(_ image: UIImage) {
        imageView.image = image
        imageView.sizeToFit()
        
        scrollView.delegate = self
        scrollView.contentSize = imageView.frame.size
        scrollView.addSubview(imageView)
        scrollView.backgroundColor = .clear
        
        let yOffset = self.calcScrollOffset()
        scrollView.frame = CGRect(
            x: view.bounds.origin.x,
            y: yOffset,
            width: view.bounds.width,
            height: view.bounds.height
        )
        
        view.addSubview(scrollView)
        
        setZoomScale()
        centerScrollViewContents()
    }
    
    func setupNavbar() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.isToolbarHidden = true
        
        let button = UIButton(type: .custom)
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        } else {
            button.setImage(UIImage(named: "back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        button.setTitle(ACAppLocale.back.locale, for: .normal)
        button.sizeToFit()
        button.setTitleColor(viewModel.configuration.appearance.tintColor, for: [])
        button.titleLabel?.font = viewModel.configuration.appearance.navBarTitleFont
        button.tintColor = viewModel.configuration.appearance.tintColor
        button.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        
        navigationItem.setLeftBarButton(UIBarButtonItem(customView: button), animated: true)
    }
    
    func calcScrollOffset() -> CGFloat {
        let navBar: UIView = self.navigationController?.navigationBar ?? UIView()
        return navBar.bounds.maxY + navBar.bounds.height
    }
}

// MARK: - Zoom
private extension PhotoPreviewViewController {
    
    func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        let yOffset = self.calcScrollOffset()
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = ((boundsSize.height - contentsFrame.size.height) / 2.0) - yOffset
        } else {
            contentsFrame.origin.y = 0.0 - yOffset
        }
        
        imageView.frame = contentsFrame
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width / scale
        
        let newCenter = imageView.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        
        return zoomRect
    }
}

// MARK: - UIScrollViewDelegate
extension PhotoPreviewViewController: UIScrollViewDelegate {
    
    open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

// MARK: - Actions
private extension PhotoPreviewViewController {
    
    @objc
    private func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func handleDoubleTap(sender: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(
                to: zoomRectForScale(
                    scale: scrollView.maximumZoomScale,
                    center: sender.location(in: sender.view)
                ),
                animated: true
            )
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }
}
