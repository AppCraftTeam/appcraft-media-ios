//
//  ACSelectedImagesStack.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import PhotosUI

/// A stack that contains assets selected by the user for their further transfer to the application
open class ACSelectedImagesStack {
    
    public init() {}
    
    open var didSelectedImagesChanged: (() -> Void)?
    
    private var selectedImageAssets: [PHAsset] = [] {
        didSet {
            didSelectedImagesChanged?()
        }
    }
    
    open var selectedCount: Int {
        selectedImageAssets.count
    }
    
    /// Checks if a given asset is in the selected images stack.
    /// - Parameter asset: The asset to check.
    /// - Returns: A boolean value indicating whether the asset is in the selected images stack.
    open func contains(_ asset: PHAsset) -> Bool {
        selectedImageAssets.contains(asset)
    }
    
    /// Deletes a given asset from the selected images stack.
    /// - Parameter asset: The asset to delete.
    open func delete(_ asset: PHAsset) {
        if let index = selectedImageAssets.firstIndex(where: { $0 == asset }) {
            selectedImageAssets.remove(at: index)
        }
    }
    
    /// Deletes all assets from the selected images stack.
    open func deleteAll() {
        selectedImageAssets.removeAll()
    }
    
    /// Getting all selected image assets.
    /// - Returns: An array of selected image assets.
    open func fetchAssets() -> [PHAsset] {
        Array(selectedImageAssets)
    }
    
    /// Adds a given asset to the selected images stack.
    /// - Parameter asset: The asset to add.
    open func add(_ asset: PHAsset) {
        if !selectedImageAssets.contains(asset) {
            selectedImageAssets += [asset]
        }
    }
    
    /// Fetches and removes the first added asset from the selected images stack.
    /// - Returns: The first added asset.
    open func fetchFirstAdded() -> PHAsset? {
        selectedImageAssets.isEmpty ? nil : selectedImageAssets.removeFirst()
    }
}
