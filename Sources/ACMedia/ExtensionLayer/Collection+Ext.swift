//
//  Collection+Ext.swift
//  
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation

extension Collection {
    
    /// Safely retrieving element from array
    subscript (safeIndex index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
