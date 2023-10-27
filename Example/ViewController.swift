//
//  ViewController.swift
//  Example
//
//  Created by AppCraft on 4 окт. 2023 г..
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit
import ACMedia

// MARK: - ViewController

/// The ViewController
class ViewController: UIViewController {
    
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
    
    lazy var openPickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Open picker", for: [])
        button.addTarget(self, action: #selector(self.openPicker), for: .touchUpInside)
        button.setTitleColor(.red, for: [])
        
        return button
    }()
    
    lazy var urlsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13.0)
        
        return label
    }()
    
    // MARK: View-Lifecycle
    
    /// View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    /// LoadView
    override func loadView() {
        self.view = self.containerStack
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        self.containerStack.addArrangedSubview(view)
        self.containerStack.addArrangedSubview(openPickerButton)
        self.containerStack.addArrangedSubview(imagesStack)
        self.containerStack.addArrangedSubview(filesStack)
        filesStack.addArrangedSubview(urlsLabel)
        self.containerStack.addArrangedSubview(UIView())
    }
    
    
    @objc
    private func openPicker() { 
        let acMedia = ACMedia(
            fileTypes: [.gallery],
            assetsSelected: { [weak self] assets in
                self?.didPickImages(assets.images)
                self?.didPickDocuments(assets.videoUrls)
            },
            filesSelected: { [weak self] fileUrls in
                self?.didPickDocuments(fileUrls)
            }
        )
        acMedia.show(in: self)
    }
    
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
