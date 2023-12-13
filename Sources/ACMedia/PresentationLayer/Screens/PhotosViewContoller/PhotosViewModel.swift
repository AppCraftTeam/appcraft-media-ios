//
//  PhotosViewModel.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import Photos
import UIKit

class PhotosViewModel {
    
    public var albumModel: AlbumModel?
    var models: [AppCellIdentifiable] = []
    
    // MARK: - Properties
    var selectedIndexPath: IndexPath?
    var imagesData = PHFetchResult<PHAsset>()
    var photoService = PhotoService()
    var albumsData: [AlbumModel] = []
    
    // MARK: - Actions
    var onReloadCollection: (() -> Void)?
    var onReloadCells: ((_ indexes: [IndexPath]) -> Void)?
    var onSetupDoneButton: (() -> Void)?
    var onShowPermissionAlert: (() -> Void)?
    var onShowEmptyPlaceholder: (() -> Void)?
    var onSetupNavbar: (() -> Void)?
    var onShowImageOnFullScreen: ((_ asset: PHAsset) -> Void)?
    var onShowCamera: (() -> Void)?
    
    lazy var loadingQueue = OperationQueue()
    lazy var loadingOperations: [IndexPath: AsyncImageLoader] = [:]
    
    func reloadData() {
        authorize()
    }
}

extension PhotosViewModel {
    
    func authorize() {
        photoService.authorize { [weak self] status in
            switch status {
            case .authorized, .limited:
                self?.fetchImageData()
                self?.fetchAlbumData()
            default:
                DispatchQueue.main.async {
                    self?.onShowPermissionAlert?()
                }
            }
        }
    }
    
    func fetchImageData() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.albumModel == nil {
                strongSelf.albumModel = strongSelf.photoService.fetchRecentsAlbum()
            }
            
            if let model = strongSelf.albumModel {
                strongSelf.imagesData = model.assets
            }
            let models = strongSelf.makeSections()
            strongSelf.models = models
            print("models: \(strongSelf.models.count)")
            strongSelf.onReloadCollection?()
        }
    }
    
    func makeSections() -> [AppCellIdentifiable] {
        var models: [AppCellIdentifiable] = []
        
        guard let model = self.albumModel else {
            return []
        }
        
        model.assets.enumerateObjects { asset, index, _ in
            models += [
                PhotoCellModel(
                    image: nil,
                    index: index,
                    isSelected: SelectedImagesStack.shared.contains(asset),
                    viewTapped: {
                        print("age selected View tapped \(index)")
                        self.selectedIndexPath = IndexPath(row: index + 1, section: 0)
                        self.onShowImageOnFullScreen?(asset)
                    },
                    viewSelectedToggle: {
                        print("age selected Toggled selection \(index), \(self.models[index])")
                        if let model = self.models[index + 1] as? PhotoCellModel {
                            self.handleImageSelection(model: model)
                        }
                    }
                )
            ]
        }
        
        if ACMediaConfiguration.shared.photoConfig.allowCamera {
            let cameraModel = CameraCellModel(viewTapped: { [weak self] in
                self?.onShowCamera?()
            })
            if models.isEmpty {
                models = [cameraModel]
            } else {
                models.insert(cameraModel, at: 0)
            }
        }
        
        if self.imagesData.count == 0 {
            onShowEmptyPlaceholder?()
            return []
        }
        
        return models
    }
    
    func fetchAlbumData() {
        albumsData = photoService.fetchAllAlbums()
        photoService.fetchPreviewsFor(albums: albumsData) { albums in
            self.albumsData = albums
            DispatchQueue.main.async { [weak self] in
                self?.onSetupNavbar?()
            }
        }
    }
  
    func handleImageSelection(model: PhotoCellModel) {
        let maxSelection = ACMediaConfig.photoConfig.maximumSelection ?? Int.max
        let asset = imagesData[model.index]
        let indexPath = IndexPath(row: model.index + 1, section: 0)

        handleMaximumSelection(maxSelection, asset, indexPath)
    }
    
    private func handleMaximumSelection(_ maxSelection: Int, _ asset: PHAsset, _ indexPath: IndexPath) {
        print("zzzz handleMaximumSelection maxSelection \(maxSelection)")
        if SelectedImagesStack.shared.contains(asset) {
            SelectedImagesStack.shared.delete(asset)
        } else {
            guard SelectedImagesStack.shared.selectedCount < maxSelection else {                
                if let oldAsset = SelectedImagesStack.shared.fetchFirstAdded() {
                    let oldIndex = imagesData.index(of: oldAsset)
                    let oldIndexPath = IndexPath(item: oldIndex + 1, section: 0)
                    SelectedImagesStack.shared.add(asset)
                    
                    let models = self.makeSections()
                    self.models = models
                    
                    self.onReloadCells?([oldIndexPath, indexPath])
                }
                
                return
            }
            SelectedImagesStack.shared.add(asset)
        }
        
        let models = makeSections()
        self.models = models
        onReloadCells?([indexPath])
        onSetupDoneButton?()
    }
}
