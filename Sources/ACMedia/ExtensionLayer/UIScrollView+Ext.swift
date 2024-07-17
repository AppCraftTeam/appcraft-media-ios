//
//  UIScrollView+Ext.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    /// Calculates the rectangle to zoom
    /// - Parameters:
    ///   - scale: The scale factor to zoom to.
    ///   - center: The center point to zoom around.
    /// - Returns: A rectangle representing the area to zoom to.
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = frame.size.height / scale
        zoomRect.size.width = frame.size.width / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}
