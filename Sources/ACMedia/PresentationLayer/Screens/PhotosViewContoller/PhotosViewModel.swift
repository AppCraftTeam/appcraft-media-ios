//
//  PhotosViewModel.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import DPUIKit
import Photos
import UIKit

class PhotosViewModel {
    
    public var albumModel: AlbumModel?
    private(set) var sections: [Section] = []

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
    var onHideEmptyPlaceholder: (() -> Void)?
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
            strongSelf.makeSections()
        }
    }
    
    func makeSections() {
        guard let model = self.albumModel else {
            return
        }
        
        var photosViewModels: [PhotoCellModel] = []
        var cameraModel: CameraCellModel?
        
        model.assets.enumerateObjects { asset, index, _ in
            photosViewModels += [
                PhotoCellModel(
                    image: nil,
                    index: index,
                    isSelected: SelectedImagesStack.shared.contains(asset),
                    viewTapped: {
                        self.selectedIndexPath = IndexPath(row: index + 1, section: 0)
                        self.onShowImageOnFullScreen?(asset)
                    },
                    viewSelectedToggle: {
                        if let model = photosViewModels[index] as? PhotoCellModel {
                            self.handleImageSelection(model: model)
                        }
                    }
                )
            ]
        }
        
        if ACMediaConfiguration.shared.photoConfig.allowCamera {
            cameraModel = CameraCellModel(viewTapped: { [weak self] in
                self?.onShowCamera?()
            })
        }
        
        self.sections.removeAll()
        self.sections = [Section(photos: photosViewModels, camera: cameraModel)]
        
        // swiftlint:disable:next empty_count
        if self.imagesData.count == 0 {
            onShowEmptyPlaceholder?()
        } else {
            onHideEmptyPlaceholder?()
        }
        
        onReloadCollection?()
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
        if SelectedImagesStack.shared.contains(asset) {
            SelectedImagesStack.shared.delete(asset)
        } else {
            guard SelectedImagesStack.shared.selectedCount < maxSelection else {                
                if let oldAsset = SelectedImagesStack.shared.fetchFirstAdded() {
                    let oldIndex = imagesData.index(of: oldAsset)
                    let oldIndexPath = IndexPath(item: oldIndex + 1, section: 0)
                    SelectedImagesStack.shared.add(asset)
                    
                    self.makeSections()
                    self.onReloadCells?([oldIndexPath, indexPath])
                }
                
                return
            }
            SelectedImagesStack.shared.add(asset)
        }
        
        self.makeSections()
        onReloadCells?([indexPath])
        onSetupDoneButton?()
    }
}

// MARK: - Section
extension PhotosViewModel {
    
    struct Section: DPCollectionSectionType, Identifiable {
        
        // MARK: - Init
        init(photos: [PhotoCellModel], camera: CameraCellModel?) {
            self.items = photos
            if let camera = camera {
                self.items.append(camera)
            }
            self.header = nil
            self.footer = nil
        }
        
        // MARK: - Props
        let id = UUID()
        var items: [Sendable]
        var header: Sendable?
        var footer: Sendable?
    }
}
