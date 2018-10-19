//
//  CollectionViewCell.swift
//  DesafioPAN
//
//  Created by Lucas Saito on 18/10/2018.
//  Copyright © 2018 Otias. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var image: UIImage?
    var title: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.image = image
        titleLabel.text = title
    }
    
    func setCell(image: UIImage, title: String) {
        self.image = image
        self.title = title
    }

}
