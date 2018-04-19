//
//  ImageCell.swift
//  FlickR Search
//
//  Created by Giovanni Palusa on 2018-04-18.
//  Copyright © 2018 Giovanni Palusa. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var titleLbl: UILabel!
    
    
    func setCell(photo: Photos) {
        
        DataManager.downloadImage(url: photo.urlToPhoto as URL) { (image) in
            self.imageView.image = image
        }
        titleLbl.text = photo.title
        
        if photo.title == "" {
            blur.isHidden = true
        }
    }
    
}
