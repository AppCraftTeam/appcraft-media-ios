//
//  ACPhotosViewModel.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import DPUIKit
import Photos
import UIKit

/// ViewModel for `ACPhotoGridViewController`
open class ACPhotosViewModel {
    
    open var albumModel: ACAlbumModel?
    private(set) var sections: [Section] = []

    // MARK: - Properties
    var configuration: ACMediaConfiguration
    var selectedAssetsStack: ACSelectedImagesStack
    var selectedIndexPath: IndexPath?
    var imagesData = PHFetchResult<PHAsset>()
    var photoService = ACPhotoService()
    var albumsData: [ACAlbumModel] = []
    
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
    
    // MARK: - Callbacks
    var didPickAssets: ACPhotosViewControllerCallback?
    var didOpenSettings: (() -> Void)?
    
    lazy var loadingQueue = OperationQueue()
    lazy var loadingOperations: [IndexPath: ACAsyncImageLoader] = [:]
    
    func reloadData() {
        authorize()
    }
    
    init(configuration: ACMediaConfiguration, selectedAssetsStack: ACSelectedImagesStack, didPickAssets: ACPhotosViewControllerCallback?, didOpenSettings: (() -> Void)?) {
        self.configuration = configuration
        self.selectedAssetsStack = selectedAssetsStack
        self.didPickAssets = didPickAssets
        self.didOpenSettings = didOpenSettings
    }
}

extension ACPhotosViewModel {
    
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
            guard let self else { return }
            if self.albumModel == nil {
                self.albumModel = self.photoService.fetchRecentAlbum()
            }
            
            if let model = self.albumModel {
                self.imagesData = model.assets
            }
            self.makeSections(isNeedUpdateView: true)
        }
    }
    
    /// Create models to represent the assets in the collection view
    func makeSections(isNeedUpdateView: Bool) {
        guard let model = self.albumModel else {
            return
        }
        
        var photosViewModels: [ACPhotoCellModel] = []
        var cameraModel: ACCameraCellModel?
        
        model.assets.enumerateObjects { asset, index, _ in
            var image: UIImage? {
                guard self.sections.first?.items.count ?? -1 >= index else {
                    return nil
                }
                return (self.sections[safeIndex: 0]?.items[safeIndex: index] as? ACPhotoCellModel)?.image
            }
            
            photosViewModels += [
                ACPhotoCellModel(
                    image: image,
                    index: index,
                    isSelected: self.selectedAssetsStack.contains(asset),
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
            cameraModel = ACCameraCellModel(
                configuration: self.configuration,
                viewTapped: { [weak self] in
                    self?.onShowCamera?()
                }
            )
        }
        
        self.sections.removeAll()
        self.sections = [Section(photos: photosViewModels, camera: cameraModel)]
        
        guard isNeedUpdateView else {
            return
        }
        
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
    func handleImageSelection(model: ACPhotoCellModel) {
        let maxSelection = configuration.photoConfig.limiter.max ?? Int.max
        guard let asset = PHAsset.getSafeElement(fetchResult: imagesData, index: model.index) else {
            return
        }
        let indexPath = IndexPath(row: model.index + 1, section: 0)

        handleMaximumSelection(maxSelection, asset, indexPath)
    }
    
    /// Asset selection processing
    /// - Parameters:
    ///   - maxSelection: Limit - how many assets maximum can be selected
    ///   - asset: Selected asset
    ///   - indexPath: Asset position in collection view
    private func handleMaximumSelection(_ maxSelection: Int, _ asset: PHAsset, _ indexPath: IndexPath) {
        if selectedAssetsStack.contains(asset) {
            selectedAssetsStack.delete(asset)
        } else {
            guard selectedAssetsStack.selectedCount < maxSelection else {
                if let oldAsset = selectedAssetsStack.fetchFirstAdded() {
                    // Unselect the first selected asset
                    let oldIndex = imagesData.index(of: oldAsset)
                    let oldIndexPath = IndexPath(item: oldIndex + 1, section: 0)
                    selectedAssetsStack.add(asset)
                    
                    self.makeSections(isNeedUpdateView: false)
                    self.onReloadCells?([oldIndexPath, indexPath])
                }
                
                return
            }
            // Add asset in stack
            selectedAssetsStack.add(asset)
        }
        
        self.makeSections(isNeedUpdateView: false)
        onReloadCells?([indexPath])
        onSetupDoneButton?()
    }
}

// MARK: - Section
extension ACPhotosViewModel {
    
    struct Section: DPCollectionSectionType, Identifiable {
        
        // MARK: - Init
        init(photos: [ACPhotoCellModel], camera: ACCameraCellModel?) {
            self.items = photos
            if let camera = camera {
                self.items.insert(camera, at: 0)
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
