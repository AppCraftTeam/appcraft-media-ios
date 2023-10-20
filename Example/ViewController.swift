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
    }
    
    
    @objc
    private func openPicker() {
        #warning("todo initial with config, ACMedia()")
        AppTabBarController().showPicker(
            in: self,
            fileFormats: [.zip]
        )
    }
}

// MARK: - DocumentsPickerDelegate
extension ViewController: DocumentsPickerDelegate {
    
    func onPickDocuments(_ urls: [URL]) {
        print("onPickDocuments - \(urls)")
        filesStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        urls.forEach({ url in
            let label = UILabel()
            label.text = url.absoluteString
            filesStack.addArrangedSubview(label)
        })
    }
}

// MARK: - PhotoPickerDelegate
extension ViewController: PhotoPickerDelegate {
    
    func didSelect(images: [UIImage]) {
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

