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
        imageView.contentMode = .scaleAspectFill //scaleAspectFit
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
        
        var image: UIImage? {
            guard let model = self.cellModel else {
                return nil
            }
            var icon = model.isSelected ? AppAssets.Icon.checkmarkFilled.image : AppAssets.Icon.checkmarkEmpty.image
            return icon?.withRenderingMode(.alwaysTemplate)
        }
        
        button.setImage(image, for: [])
        button.tintColor = .white
        
        button.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func updateViews() {
        guard let model = self.cellModel else {
            return
        }
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.layer.cornerRadius = 10.0
        print("updateViews \(model.isSelected)")
        self.setupComponents()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        previewImageView.image = nil
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let event, event.type == .touches,
              let model = self.cellModel else {
            return
        }
        self.backgroundColor = .red
        self.cellModel?.viewTapped?()
    }
    
    @objc
    private func checkButtonTapped() {
        self.backgroundColor = .yellow
        //self.cellModel?.isSelected.toggle()
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
        
        cellOverlay.addSubview(checkButton)
        
        checkButton.snp.makeConstraints {
            $0.size.equalTo(24)
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
            self.previewImageView.contentMode = image != nil ? .scaleAspectFit : .scaleToFill
        }
    }
    
    func changeSelection(state isSelected: Bool) {
        //cellOverlay.isHidden = !isSelected
    }
    
    func getPreviewImageView() -> UIImageView? {
        return previewImageView
    }
}
