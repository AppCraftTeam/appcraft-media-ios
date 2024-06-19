//
//  ACSelectedImagesStack.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import PhotosUI

#warning("without singltone")
/// A stack that contains assets selected by the user for their further transfer to the application
open class ACSelectedImagesStack {
    
    private var selectedImageAssets: [PHAsset] = [] {
        didSet {
            NotificationCenter.default.post(name: .onSelectedImagesChanged, object: nil)
        }
    }
    
    public static let shared = ACSelectedImagesStack()
    
    private init() {}
    
    open var selectedCount: Int {
        selectedImageAssets.count
    }
    
    open func contains(_ asset: PHAsset) -> Bool {
        selectedImageAssets.contains(asset)
    }
    
    open func delete(_ asset: PHAsset) {
        if let index = selectedImageAssets.firstIndex(where: { $0 == asset }) {
            selectedImageAssets.remove(at: index)
        }
    }
    
    open func deleteAll() {
        selectedImageAssets.removeAll()
    }
    
    open func fetchAssets() -> [PHAsset] {
        Array(selectedImageAssets)
    }
    
    open func add(_ asset: PHAsset) {
        if !selectedImageAssets.contains(asset) {
            selectedImageAssets += [asset]
        }
    }
    
    open func fetchFirstAdded() -> PHAsset? {
        selectedImageAssets.removeFirst()
    }
}
