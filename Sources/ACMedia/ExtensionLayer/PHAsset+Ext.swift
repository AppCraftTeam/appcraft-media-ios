//
//  PHAsset+Ext.swift
//
//
//  Created by Pavel Moslienko on 15.07.2024.
//

import Foundation
import Photos

extension PHAsset {

    static func getSafeElement(fetchResult: PHFetchResult<PHAsset>, index: Int) -> PHAsset? {
        guard index >= 0 && index < fetchResult.count else {
            return nil
        }
        
        let asset = fetchResult.object(at: index)
        return asset
    }
}
