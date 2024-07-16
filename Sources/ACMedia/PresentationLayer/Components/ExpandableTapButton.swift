//
//  ExpandableTapButton.swift
//
//
//  Created by Pavel Moslienko on 15.07.2024.
//

import Foundation
import UIKit

/// Custom button with the ability to increase the button tap area
class ExpandableTapButton: UIButton {
    
    var margin: CGFloat = 20.0
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        bounds.insetBy(dx: -margin, dy: -margin).contains(point)
    }
}
