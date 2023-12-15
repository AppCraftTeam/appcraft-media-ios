//
//  PhotoCell.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import PhotosUI
import UIKit

public class PhotoCell: AppCollectionCell<PhotoCellModel> {
    
    private(set) lazy var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private(set) lazy var cellOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    private(set) lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: [])
        button.backgroundColor = .clear
        button.tintColor = .white
        button.imageEdgeInsets = .zero
        if #available(iOSApplicationExtension 13.0, *) {
            button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 48), forImageIn: .normal)
        }
        
        button.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func updateViews() {
        self.setupComponents()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        previewImageView.image = nil
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.backgroundColor = .clear
        self.previewImageView.layer.cornerRadius = ACMediaConfiguration.shared.appearance.previewCardCornerRadius
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let event, event.type == .touches else {
            return
        }
        self.cellModel?.viewTapped?()
    }
    
    @objc
    private func checkButtonTapped() {
        self.cellModel?.isSelected.toggle()
        self.cellModel?.viewSelectedToggle?()
        self.updateViews()
    }
}

private extension PhotoCell {
    
    func setupComponents() {
        var image: UIImage? {
            guard let model = self.cellModel else {
                return nil
            }
            let icon = model.isSelected ? AppAssets.Icon.checkmarkFilled.image : AppAssets.Icon.checkmarkEmpty.image
            return icon?.withRenderingMode(.alwaysTemplate)
        }
        
        checkButton.setImage(image, for: [])
        cellOverlay.isHidden = false
        
        contentView.addSubview(previewImageView)
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            previewImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            previewImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            previewImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        contentView.addSubview(cellOverlay)
        cellOverlay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellOverlay.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellOverlay.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellOverlay.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellOverlay.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        cellOverlay.addSubview(checkButton)
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkButton.widthAnchor.constraint(equalToConstant: 44),
            checkButton.heightAnchor.constraint(equalToConstant: 44),
            checkButton.topAnchor.constraint(equalTo: cellOverlay.topAnchor, constant: 4.0),
            checkButton.trailingAnchor.constraint(equalTo: cellOverlay.trailingAnchor, constant: -4.0)
        ])
    }
}

public extension PhotoCell {
    
    func updateThumbImage(_ image: UIImage?) {
        DispatchQueue.main.async {
            self.previewImageView.image = image
        }
    }
    
    func getPreviewImageView() -> UIImageView? {
        previewImageView
    }
}
