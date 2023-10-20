//
//  AppCollectionCell.swift
//

import Foundation
import UIKit

public class AppCollectionCell<T: AppCellIdentifiable>: UICollectionViewCell {
    
    var cellModel: T? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() { }
}
