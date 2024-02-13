//
//  ViewController.swift
//  Example
//
//  Created by AppCraft on 4 окт. 2023 г..
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit
import ACMedia

class ViewController: UIViewController {
    
    // MARK: - UI components
    lazy var containerStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16.0
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()
    
    lazy var imagesStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    lazy var filesStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()
    
    lazy var openSingleImagePickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Open picker for selecting 1 image", for: [])
        button.addTarget(self, action: #selector(self.openSingleImagePicker), for: .touchUpInside)
        button.setTitleColor(.red, for: [])
        
        return button
    }()
    
    lazy var openMultipleImageAndFilesPickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Open picker for multiple images or files", for: [])
        button.addTarget(self, action: #selector(self.openImageAndFilesPicker), for: .touchUpInside)
        button.setTitleColor(.orange, for: [])
        
        return button
    }()
    
    lazy var openFilesPickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Open files picker", for: [])
        button.addTarget(self, action: #selector(self.openFilesPicker), for: .touchUpInside)
        button.setTitleColor(.purple, for: [])
        
        return button
    }()
    
    lazy var urlsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13.0)
        
        return label
    }()
    
    // MARK: - View-Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override func loadView() {
        self.view = self.containerStack
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        [view, openSingleImagePickerButton, openMultipleImageAndFilesPickerButton, openFilesPickerButton, imagesStack, filesStack].forEach({
            self.containerStack.addArrangedSubview($0)
        })
        filesStack.addArrangedSubview(urlsLabel)
        self.containerStack.addArrangedSubview(UIView())
    }
}

// MARK: - Module methods
private extension ViewController {
    
    @objc
    func openSingleImagePicker() {
        let acMedia = ACMediaViewController(
            fileType: .gallery,
            assetsSelected: { [weak self] assets in
                self?.didPickImages(assets.images)
                self?.didPickDocuments(assets.videoUrls)
            }
        )
        
        acMedia.didOpenSettings = {
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
        }
        
        ACMediaConfiguration.shared.appearance = ACMediaAppearance(tintColor: .red)
        ACMediaConfiguration.shared.photoConfig = ACMediaPhotoPickerConfig(types: [.photo], limiter: .onlyOne)
        
        acMedia.show(in: self)
    }
    
    @objc
    func openImageAndFilesPicker() {
        let acMedia = ACMediaViewController(
            fileType: .galleryAndFiles,
            assetsSelected: { [weak self] assets in
                self?.didPickImages(assets.images)
                self?.didPickDocuments(assets.videoUrls)
            },
            filesSelected: { [weak self] fileUrls in
                self?.didPickDocuments(fileUrls)
            }
        )
        
        ACMediaConfiguration.shared.appearance = ACMediaAppearance(tintColor: .orange)
        ACMediaConfiguration.shared.photoConfig = ACMediaPhotoPickerConfig(types: [.photo, .video], limiter: .limit(min: 2, max: 4))
        ACMediaConfiguration.shared.documentsConfig = ACMediaPhotoDocConfig(fileFormats: [.zip])
        
        acMedia.show(in: self)
    }
    
    @objc
    func openFilesPicker() {
        let acMedia = ACMediaViewController(
            fileType: .files,
            filesSelected: { [weak self] fileUrls in
                self?.didPickDocuments(fileUrls)
            }
        )
        
        ACMediaConfiguration.shared.appearance = ACMediaAppearance(tintColor: .purple)
        ACMediaConfiguration.shared.documentsConfig = ACMediaPhotoDocConfig(fileFormats: [.zip])
        
        acMedia.show(in: self)
    }
}

// MARK: - Handle picker result
private extension ViewController {
    
    func didPickDocuments(_ urls: [URL]) {
        print("onPickDocuments - \(urls)")
        urlsLabel.text = urls.map({ $0.absoluteString }).joined(separator: ", ")
    }
    
    func didPickImages(_ images: [UIImage]) {
        print("didSelect - \(images.count)")
        imagesStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        images.forEach({ img in
            let imageView = UIImageView(image: img)
            imageView.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
            imagesStack.addArrangedSubview(imageView)
        })
    }
}
