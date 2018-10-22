//
//  CollectionViewCell.swift
//  DesafioPAN
//
//  Created by Lucas Saito on 18/10/2018.
//  Copyright © 2018 Otias. All rights reserved.
//

import UIKit

class FilmeCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCell(imageURL: String?, title: String?) {
        imageView.loadImageUsingCache(withUrl: imageURL!)
        titleLabel.text = title
    }

}
