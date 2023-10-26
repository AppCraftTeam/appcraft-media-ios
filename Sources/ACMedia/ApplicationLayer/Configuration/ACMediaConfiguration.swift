//
//  ACMediaConfiguration.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import Foundation

internal var ACMediaConfig: ACMediaConfiguration {
    ACMediaConfiguration.shared
}
#warning("todo public or internal everywhere")

public struct ACMediaConfiguration {
    
    public static var shared: ACMediaConfiguration = ACMediaConfiguration()
    
    public init() {}
    
    public let appearance = ACMediaAppearance()
    public let photoConfig = ACMediaPhotoPickerConfig()
    public let documentsConfig = ACMediaPhotoDocConfig()
}
