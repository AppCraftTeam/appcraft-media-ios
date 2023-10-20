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
                model.assets.enumerateObjects { asset, index, _ in
                    strongSelf.models += [
                        PhotoCellModel(
                            image: nil,
                            isSelected: SelectedImagesStack.shared.contains(asset),
                            viewTapped: {
                                print("View tapped")
                                strongSelf.selectedIndexPath = IndexPath(row: index, section: 0)
                                strongSelf.onShowImageOnFullScreen?(asset)
                            },
                            viewSelectedToggle: {
                                print("Toggled selection")
                                strongSelf.selectedImage(indexPath: IndexPath(row: index, section: 0))
                            }
                        )
                    ]
                }
                
                let cameraModel = CameraCellModel(viewTapped: { [weak self] in
                    self?.onShowCamera?()
                })
                if strongSelf.models.isEmpty {
                    strongSelf.models = [cameraModel]
                } else {
                    strongSelf.models.insert(cameraModel, at: 0)
                }
                
                if strongSelf.imagesData.count == 0 {
                    strongSelf.onShowEmptyPlaceholder?()
                    return
                }
            }
            print("models: \(strongSelf.models.count)")
            strongSelf.onReloadCollection?()
        }
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
    
#warning("todo without indexpath")
    func selectedImage(indexPath: IndexPath) {
        let index = indexPath.item
        let asset = imagesData[index]
        print("Image selected at indexPath \(indexPath)")
        
        (models[indexPath.row] as? PhotoCellModel)?.isSelected.toggle()
        
        let maxSelection = ACMediaConfig.photoConfig.selectionLimit
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
                let oldIndexPath = IndexPath(item: oldIndex, section: 0)
                SelectedImagesStack.shared.add(asset)
                self.onReloadCells?([oldIndexPath, indexPath])
            } else {
                SelectedImagesStack.shared.add(asset)
                self.onReloadCells?([indexPath])
            }
        } else {
            // Multiple
            if SelectedImagesStack.shared.contains(asset) {
                SelectedImagesStack.shared.delete(asset)
            } else {
                guard SelectedImagesStack.shared.selectedCount < maxSelection else { return }
                SelectedImagesStack.shared.add(asset)
            }
            self.onReloadCells?([indexPath])
        }
        
        self.onSetupDoneButton?()
    }
}
