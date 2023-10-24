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
                            self.selectedImage(model: model)
                        }
                    }
                )
            ]
        }
        
        let cameraModel = CameraCellModel(viewTapped: { [weak self] in
            self?.onShowCamera?()
        })
        if models.isEmpty {
            models = [cameraModel]
        } else {
            models.insert(cameraModel, at: 0)
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
    
    func selectedImage(model: PhotoCellModel) {
        let maxSelection = ACMediaConfig.photoConfig.selectionLimit
        print("Image selected at index \(model.index) is \(model.isSelected), all \(SelectedImagesStack.shared.selectedCount)")
        let asset = imagesData[model.index]
        let indexPath = IndexPath(row: model.index + 1, section: 0)
        
        if maxSelection == 1 {
            // Single
            guard !SelectedImagesStack.shared.contains(asset) else {
                SelectedImagesStack.shared.delete(asset)
                self.onReloadCells?([indexPath])
                self.onSetupDoneButton?()
                return
            }
            if let oldAsset = SelectedImagesStack.shared.fetchFirstAdded() {
                let oldIndex = imagesData.index(of: oldAsset)
                let oldIndexPath = IndexPath(item: oldIndex + 1, section: 0)
                print("oldIndexPath - \(oldIndexPath), indexPath \(indexPath)")
                SelectedImagesStack.shared.add(asset)
                
                let models = self.makeSections()
                self.models = models
                
                self.onReloadCells?([oldIndexPath, indexPath])
            } else {
                SelectedImagesStack.shared.add(asset)
                
                
                let models = self.makeSections()
                self.models = models
                
                self.onReloadCells?([indexPath])
            }
        } else {
            //Multiple
            if SelectedImagesStack.shared.contains(asset) {
                SelectedImagesStack.shared.delete(asset)
            } else {
                guard SelectedImagesStack.shared.selectedCount < maxSelection else { return }
                SelectedImagesStack.shared.add(asset)
            }
            
            let models = self.makeSections()
            self.models = models
            
            self.onReloadCells?([indexPath])
        }
        
        let cells = self.models.filter({ $0 is PhotoCellModel }).map({ $0 as? PhotoCellModel })
        print("ssss maxSelection - \(maxSelection), status \(cells.map({ "id \($0?.index) is \($0?.isSelected)"  }))")
        
        self.onSetupDoneButton?()
    }
}
