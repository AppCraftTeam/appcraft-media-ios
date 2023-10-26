//
//  PhotoPreviewViewController.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import PhotosUI
import UIKit

public final class PhotoPreviewViewController: UIViewController {
    var photoService = PhotoService()
    
    // MARK: - Components
    var displayPhotoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        if ACMediaConfig.appearance.allowsPhotoPreviewZoom {
            scrollView.delegate = self
            let doubleTap = UITapGestureRecognizer(
                target: self,
                action: #selector(handleDoubleTapOnScrollView(_:)))
            doubleTap.numberOfTapsRequired = 2
            scrollView.addGestureRecognizer(doubleTap)
            scrollView.maximumZoomScale = 5.0
        }
        
        return scrollView
    }()
    
    // MARK: - Params
    public var asset: PHAsset!
    public var image: UIImage!
    public var portraitConstraint: CGFloat!
    public var landscapeConstraint: CGFloat!
    
    private var sizeConstraints: [NSLayoutConstraint] = []
    private var initConstraints: [NSLayoutConstraint] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        adjustToolbar()
        
        configureScrollView()
        setInitPhotoConfig()
        loadPhoto()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        finalPhotoConfig()
        adjustZoomScale()
    }
    
    private func adjustToolbar() {
        navigationController?.isToolbarHidden = false
        toolbarItems = navigationController?.toolbarItems
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            view.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            guide.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func setInitPhotoConfig() {
        view.addSubview(displayPhotoView)
        
        let guide = view.safeAreaLayoutGuide
        initConstraints = [
            displayPhotoView.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            displayPhotoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            displayPhotoView.widthAnchor.constraint(equalTo: view.widthAnchor),
            displayPhotoView.heightAnchor.constraint(equalToConstant: portraitConstraint)
        ]
        
        NSLayoutConstraint.activate(initConstraints)
    }
    
    private func finalPhotoConfig() {
        NSLayoutConstraint.deactivate(initConstraints)
        
        displayPhotoView.removeFromSuperview()
        scrollView.addSubview(displayPhotoView)
        
        if displayPhotoView.image == nil {
            displayPhotoView.image = image
        }
        
        NSLayoutConstraint.activate([
            displayPhotoView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            displayPhotoView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            reinitImageConstraints(),
            scrollView.rightAnchor.constraint(equalTo: displayPhotoView.rightAnchor)
        ])
        
        adjustSizeConstraints()
    }
    
    private func reinitImageConstraints() -> NSLayoutConstraint{
        scrollView.bottomAnchor.constraint(equalTo: displayPhotoView.bottomAnchor)
    }
    
    private func adjustSizeConstraints() {
        NSLayoutConstraint.deactivate(sizeConstraints)
        
        let ratio = image.size.width / image.size.height
        let imageViewHeight = view.frame.size.width / ratio
        sizeConstraints = [
            displayPhotoView.widthAnchor.constraint(equalTo: view.widthAnchor),
            displayPhotoView.heightAnchor.constraint(equalToConstant: imageViewHeight)
        ]
        NSLayoutConstraint.activate(sizeConstraints)
    }
    
    private func adjustZoomScale() {
        let imageViewSize = displayPhotoView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.zoomScale = 1.0
    }
    
    private func loadPhoto() {
        photoService.fetchOriginalImage(for: asset, size: displayPhotoView.frame.size) { [weak self] image in
            guard let image = image else {
                return
            }
            self?.displayPhotoView.image = image
        }
    }
    
    @objc
    private func reactToRotation() {
        adjustSizeConstraints()
    }
    
    @objc
    private func handleDoubleTapOnScrollView(_ recognizer: UIGestureRecognizer) {
        if scrollView.zoomScale >= scrollView.maximumZoomScale / 2.0 {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            let center = recognizer.location(in: recognizer.view)
            let zoomRect = scrollView.zoomRectForScale(3 * scrollView.minimumZoomScale, center: center)
            scrollView.zoom(to: zoomRect, animated: true)
        }
    }
}

//MARK: - ZoomTransitionViewController
extension PhotoPreviewViewController: ZoomTransitionViewController {
    
    public func getZoomingImageView(for transition: ZoomTransitionDelegate) -> UIImageView? {
        displayPhotoView
    }
}

// MARK: - UIScrollViewDelegate
extension PhotoPreviewViewController: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        displayPhotoView
    }
    
    func setZoomScale() {
        let imageViewSize = displayPhotoView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.zoomScale = 1.0
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = displayPhotoView.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ?
        (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ?
        (scrollViewSize.width - imageViewSize.width) / 2 : 0
        scrollView.contentInset = UIEdgeInsets(
            top: verticalPadding,
            left: horizontalPadding,
            bottom: verticalPadding,
            right: horizontalPadding)
    }
}
