//
//  AppColors.swift
//  Example
//
//  Created by Pavel Moslienko on 12.07.2024.
//

import UIKit

enum AppColors: Int, CaseIterable {
    case blue = 0
    case red = 1
    case orange = 2
    
    var color: UIColor {
        switch self {
        case .blue:
            return .systemBlue
        case .red:
            return .systemRed
        case .orange:
            return .orange
        }
    }
    
    var name: String {
        switch self {
        case .blue:
            return "Blue"
        case .red:
            return "Red"
        case .orange:
            return "Orange"
        }
    }
}
