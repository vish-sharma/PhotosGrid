//
//  PhotosCollectionViewCell.swift
//  PhotosGrid
//
//  Created by Omm on 7/1/18.
//  Copyright © 2018 Vishal Sharma. All rights reserved.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func loadPhoto(photo: UIImage) {
        photoView.image = photo
    }

}
