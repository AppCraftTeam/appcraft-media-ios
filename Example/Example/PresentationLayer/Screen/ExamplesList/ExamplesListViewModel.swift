//
//  ExamplesListViewModel.swift
//  Example
//
//  Created by Pavel Moslienko on 12.07.2024.
//

import Foundation
import UIKit

final class ExamplesListViewModel {
    
    let examples = ExampleType.allCases
    var images: [UIImage] = []
    var files: [URL] = []
}
