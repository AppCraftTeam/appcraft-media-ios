//
//  PhotoCell.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import PhotosUI
import SnapKit
import UIKit

public class PhotoCell: AppCollectionCell<PhotoCellModel> {
    
    private(set) lazy var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill //.scaleToFill
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
        contentView.addSubview(previewImageView)
        previewImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        contentView.addSubview(cellOverlay)
        cellOverlay.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        var image: UIImage? {
            guard let model = self.cellModel else {
                return nil
            }
            let icon = model.isSelected ? AppAssets.Icon.checkmarkFilled.image : AppAssets.Icon.checkmarkEmpty.image
            return icon?.withRenderingMode(.alwaysTemplate)
        }
        
        checkButton.setImage(image, for: [])
        
        cellOverlay.addSubview(checkButton)
        
        checkButton.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.top.equalToSuperview().inset(4.0)
            $0.right.equalToSuperview().inset(4.0)
        }
        cellOverlay.isHidden = false
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
