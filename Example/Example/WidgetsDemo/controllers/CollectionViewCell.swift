//
//  CollectionViewCell.swift
//  Example
//
//  Created by Guy Daher on 14/04/2017.
//
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var salePrice: UILabel!
}
