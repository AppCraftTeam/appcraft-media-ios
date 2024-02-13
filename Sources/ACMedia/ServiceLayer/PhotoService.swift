//
//  PhotoService.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import PhotosUI
import UIKit

public final class PhotoService: NSObject {
    
    /// Types of files from the gallery that will be displayed in the picker
    public var fileTypes: [PhotoPickerFilesType] = PhotoPickerFilesType.allCases
    
    /// Request permission to access your camera roll
    /// - Parameter completion: Auth status
    public func authorize(completion: @escaping (PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization(completion)
    }
    
    /// Get the "recent photos" album
    /// - Returns: Album info model
    public func fetchRecentAlbum() -> AlbumModel? {
        let options = PHFetchOptions()
        
        let smartCollections = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .smartAlbumUserLibrary,
            options: options)
        
        let recentCollections = smartCollections.object(at: 0)
        var albumData: AlbumModel?
        if let name = recentCollections.localizedTitle {
            let assetsCollection = pullAssets(fromCollection: recentCollections)
            albumData = AlbumModel(title: name, assets: assetsCollection)
        }
        
        return albumData
    }
    
    /// Get a list of all albums from camera roll
    /// - Returns: Album info models
    public func fetchAllAlbums() -> [AlbumModel] {
        let options = PHFetchOptions()
        
        let userAlbums = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .albumRegular,
            options: options
        )
        let smartCollections = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .smartAlbumUserLibrary,
            options: options
        )
        let allCollections = [smartCollections, userAlbums]
        var albums: [AlbumModel] = []
        
        for album in allCollections {
            album.enumerateObjects { [unowned self] (collection, _, _) in
                if let name = collection.localizedTitle {
                    let assetCollection = pullAssets(fromCollection: collection)
                    albums.append(AlbumModel(title: name, assets: assetCollection))
                }
            }
        }
        return albums
    }
    
    /// Get preview image for albums
    /// - Parameters:
    ///   - albums: Album info models without preview
    ///   - completion: Album info models wuth preview
    public func fetchPreviewsFor(albums: [AlbumModel], completion: @escaping ([AlbumModel]) -> Void) {
        var albumData = albums
        var completionFlags: [Bool] = []
        
        albums.enumerated().forEach({ (index, album) in
            guard let asset = album.assets.lastObject,
                  albumData[index].previewImage == nil else {
                
                completionFlags += [false]
                if completionFlags.count == albumData.count {
                    completion(albumData)
                }
                return
            }
            
            let size = CGSize(width: 30, height: 30)
            // Fetch mini preview for album
            self.fetchThumbnail(for: asset, size: size) { image in
                albumData[index].previewImage = image
                completionFlags += [image != nil]
                if completionFlags.count == albumData.count {
                    completion(albumData)
                }
            }
        })
    }
    
    /// Request all assets from a photo collection
    /// - Parameter collection: Photo collection
    /// - Returns: Assets
    private func pullAssets(fromCollection collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
        let optionsOfPhotos = PHFetchOptions()
        optionsOfPhotos.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        var predicates: NSPredicate {
            if self.fileTypes.count == PhotoPickerFilesType.allCases.count {
                let videoPred = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue) // video
                let imagePred = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue) // photo
                let compoundPred = NSCompoundPredicate(orPredicateWithSubpredicates: [videoPred, imagePred])
                return compoundPred
            }
            return NSPredicate(format: "mediaType = %d", self.fileTypes[0].mediaType.rawValue)
        }
        
        optionsOfPhotos.predicate = predicates
        
        return PHAsset.fetchAssets(in: collection, options: optionsOfPhotos)
    }
    
    /// Get a preview thumbnail for an asset
    /// - Parameters:
    ///   - asset: Image asset
    ///   - size: Required preview size
    ///   - completion: Image preview object
    public func fetchThumbnail(for asset: PHAsset, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        let imageOptions = PHImageRequestOptions()
        imageOptions.resizeMode = .none
        imageOptions.deliveryMode = .highQualityFormat
        PHCachingImageManager.default().requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFill,
            options: imageOptions
        ) { (image, _) in
            completion(image)
        }
    }
    
    /// Get original image from asset
    /// - Parameters:
    ///   - asset: Image asset
    ///   - size: Image size, if necessary
    ///   - completion: Full image
    public func fetchOriginalImage(for asset: PHAsset, size: CGSize? = nil, completion: @escaping (UIImage?) -> Void) {
        let imageOptions = PHImageRequestOptions()
        imageOptions.deliveryMode = .highQualityFormat
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: size ?? CGSize(),
            contentMode: .aspectFit,
            options: imageOptions
        ) { (image, _) in
            completion(image)
        }
    }
    
    /// Get original image from assets array
    /// - Parameters:
    ///   - assets: Image (video) assets
    ///   - completionHandler: Original images
    public func fetchHighResImages(for assets: [PHAsset], completionHandler: @escaping ([UIImage]) -> Void) {
        var images: [UIImage] = []
        let group = DispatchGroup()
        
        let imageOptions = PHImageRequestOptions()
        imageOptions.isSynchronous = true
        imageOptions.deliveryMode = .highQualityFormat
        
        for asset in assets {
            group.enter()
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: .init(),
                contentMode: .aspectFill,
                options: imageOptions
            ) { (image, _) in
                if let img = image {
                    images += [img]
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completionHandler(images)
        }
    }
    
    /// Get full path to video files from gallery
    /// - Parameters:
    ///   - assets: Video assets
    ///   - completionHandler: video urls
    public func fetchVideoURL(for assets: [PHAsset], completionHandler: @escaping ([URL]) -> Void) {
        var urls: [URL] = []
        let group = DispatchGroup()
        let options = PHVideoRequestOptions()
        options.version = .original
        
        for asset in assets {
            group.enter()
            PHImageManager.default().requestAVAsset(
                forVideo: asset,
                options: options
            ) { avAsset, _, _ in
                guard let avURLAsset = avAsset as? AVURLAsset else {
                    group.leave()
                    return
                }
                
                let videoURL = avURLAsset.url
                urls += [videoURL]
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completionHandler(urls)
        }
    }
}
