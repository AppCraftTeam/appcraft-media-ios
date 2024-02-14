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

public class PhotosViewModel {
    
    public var albumModel: AlbumModel?
    private(set) var sections: [Section] = []

    // MARK: - Properties
    var configuration: ACMediaConfiguration
    var selectedIndexPath: IndexPath?
    var imagesData = PHFetchResult<PHAsset>()
    var photoService = PhotoService()
    var albumsData: [AlbumModel] = []
    
    // MARK: - Actions
    var onReloadCollection: ((_ sections: [Section]) -> Void)?
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
    
    init(configuration: ACMediaConfiguration) {
        self.configuration = configuration
    }
}

extension PhotosViewModel {
    
    /// Request access to a user's gallery
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
    
    /// Request an asset list for the selected album
    func fetchImageData() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.albumModel == nil {
                strongSelf.albumModel = strongSelf.photoService.fetchRecentAlbum()
            }
            
            if let model = strongSelf.albumModel {
                strongSelf.imagesData = model.assets
            }
            strongSelf.makeSections()
        }
    }
    
    /// Create models to represent the assets in the collection view
    func makeSections() {
        guard let model = self.albumModel else {
            return
        }
        
        var photosViewModels: [PhotoCellModel] = []
        var cameraModel: CameraCellModel?
        
        model.assets.enumerateObjects { asset, index, _ in
            var image: UIImage? {
                guard self.sections.first?.items.count ?? -1 >= index else {
                    return nil
                }
                return (self.sections[safeIndex: 0]?.items[safeIndex: index] as? PhotoCellModel)?.image
            }
            
            photosViewModels += [
                PhotoCellModel(
                    image: image,
                    index: index,
                    isSelected: SelectedImagesStack.shared.contains(asset),
                    configuration: self.configuration,
                    viewTapped: {
                        // Open photo in full screen preview
                        self.selectedIndexPath = IndexPath(row: index + 1, section: 0)
                        self.onShowImageOnFullScreen?(asset)
                    },
                    viewSelectedToggle: {
                        // Change selection status
                        if let model = photosViewModels[safeIndex: index] {
                            self.handleImageSelection(model: model)
                        }
                    }
                )
            ]
        }
        
        // Try add camera cell
        if configuration.photoConfig.allowCamera {
            cameraModel = CameraCellModel(
                configuration: self.configuration,
                viewTapped: { [weak self] in
                    self?.onShowCamera?()
                }
            )
        }
        
        self.sections.removeAll()
        self.sections = [Section(photos: photosViewModels, camera: cameraModel)]
        
        //Placeholder
        // swiftlint:disable:next empty_count
        if self.imagesData.count == 0 {
            onShowEmptyPlaceholder?()
        } else {
            onHideEmptyPlaceholder?()
        }
        
        onReloadCollection?(self.sections)
    }
    
    /// Get albums list
    func fetchAlbumData() {
        albumsData = photoService.fetchAllAlbums()
        photoService.fetchPreviewsFor(albums: albumsData) { albums in
            self.albumsData = albums
            DispatchQueue.main.async { [weak self] in
                self?.onSetupNavbar?()
            }
        }
    }
    
    /// Processing asset selection
    /// - Parameter model: Selection photo cell model
    func handleImageSelection(model: PhotoCellModel) {
        let maxSelection = configuration.photoConfig.maximumSelection ?? Int.max
        let asset = imagesData[model.index]
        let indexPath = IndexPath(row: model.index + 1, section: 0)

        handleMaximumSelection(maxSelection, asset, indexPath)
    }
    
    /// Asset selection processing
    /// - Parameters:
    ///   - maxSelection: Limit - how many assets maximum can be selected
    ///   - asset: Selected asset
    ///   - indexPath: Asset position in collection view
    private func handleMaximumSelection(_ maxSelection: Int, _ asset: PHAsset, _ indexPath: IndexPath) {
        if SelectedImagesStack.shared.contains(asset) {
            SelectedImagesStack.shared.delete(asset)
        } else {
            guard SelectedImagesStack.shared.selectedCount < maxSelection else {                
                if let oldAsset = SelectedImagesStack.shared.fetchFirstAdded() {
                    // Unselect the first selected asset
                    let oldIndex = imagesData.index(of: oldAsset)
                    let oldIndexPath = IndexPath(item: oldIndex + 1, section: 0)
                    SelectedImagesStack.shared.add(asset)
                    
                    self.makeSections()
                    self.onReloadCells?([oldIndexPath, indexPath])
                }
                
                return
            }
            // Add asset in stack
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
