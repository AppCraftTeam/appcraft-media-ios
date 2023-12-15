//
//  SelectedImagesStack.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation
import PhotosUI

public class SelectedImagesStack {
    
    private var selectedImageAssets: [PHAsset] = [] {
        didSet {
            NotificationCenter.default.post(name: .onSelectedImagesChanged, object: nil)
        }
    }
    
    public static let shared = SelectedImagesStack()
    
    private init() {}
    
    public var selectedCount: Int {
        selectedImageAssets.count
    }
    
    public func contains(_ asset: PHAsset) -> Bool {
        selectedImageAssets.contains(asset)
    }
    
    public func delete(_ asset: PHAsset) {
        if let index = selectedImageAssets.firstIndex(where: { $0 == asset }) {
            selectedImageAssets.remove(at: index)
        }
    }
    
    public func deleteAll() {
        selectedImageAssets.removeAll()
    }
    
    public func fetchAssets() -> [PHAsset] {
        Array(selectedImageAssets)
    }
    
    public func add(_ asset: PHAsset) {
        if !selectedImageAssets.contains(asset) {
            selectedImageAssets += [asset]
        }
    }
    
    public func fetchFirstAdded() -> PHAsset? {
        selectedImageAssets.removeFirst()
    }
}
