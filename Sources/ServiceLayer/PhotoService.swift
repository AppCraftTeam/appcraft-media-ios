//
//  PhotoService.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import PhotosUI
import UIKit

internal final class PhotoService: NSObject {
    
    public var fileTypes: [PhotoPickerFilesType] = PhotoPickerFilesType.allCases
    
    public func authorize(completion: @escaping (PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization(completion)
    }
    
    public func fetchRecentsAlbum() -> AlbumModel? {
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
    
    public func fetchAllAlbums() -> [AlbumModel] {
        let options = PHFetchOptions()
        
        let userAlbums = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .albumRegular,
            options: options)
        let smartCollections = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .smartAlbumUserLibrary,
            options: options)
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
            let dimensions = CGSize(width: 30, height: 30)
            
            self.fetchThumbnail(for: asset, size: dimensions) { image in
                albumData[index].previewImage = image
                completionFlags += [image != nil]
                if completionFlags.count == albumData.count {
                    completion(albumData)
                }
            }
        })
    }
    
    private func pullAssets(fromCollection collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
        let optionsOfPhotos = PHFetchOptions()
        optionsOfPhotos.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        var predicates: NSPredicate {
            if self.fileTypes.count == PhotoPickerFilesType.allCases.count {
                let videoPred = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
                let imagePred = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                let compoundPred = NSCompoundPredicate(orPredicateWithSubpredicates: [videoPred, imagePred])
                return compoundPred
            }
            return NSPredicate(format: "mediaType = %d", self.fileTypes[0].mediaType.rawValue)
        }
        
        optionsOfPhotos.predicate = predicates
        
        return PHAsset.fetchAssets(in: collection, options: optionsOfPhotos)
    }
    
    public func fetchThumbnail(for asset: PHAsset, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        let imageOptions = PHImageRequestOptions()
        imageOptions.resizeMode = .none
        imageOptions.deliveryMode = .highQualityFormat
        PHCachingImageManager.default().requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFill,
            options: imageOptions) { (image, _) in
                completion(image)
            }
    }
    
    public func fetchOriginalImage(for asset: PHAsset, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        let imageOptions = PHImageRequestOptions()
        imageOptions.deliveryMode = .highQualityFormat
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: .init(),
            contentMode: .aspectFit,
            options: imageOptions) { (image, _) in
                completion(image)
            }
    }
    
    public func fetchHighResImages(for assets: [PHAsset]) -> [UIImage] {
        var images: [UIImage] = []
        
        let imageOptions = PHImageRequestOptions()
        imageOptions.isSynchronous = true
        imageOptions.deliveryMode = .highQualityFormat
        
        for asset in assets {
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: .init(),
                contentMode: .aspectFill,
                options: imageOptions) { (image, _) in
                    if let img = image {
                        images.append(img)
                    }
                }
        }
        return images
    }
}
