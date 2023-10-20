//
//  Bundle+Ext.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation

private class BundleHelper {}

public extension Bundle {
    
    static var local: Bundle {
#if SWIFT_PACKAGE
        return Bundle.module
#else
        return Bundle(for: BundleHelper.self)
#endif
    }
}
