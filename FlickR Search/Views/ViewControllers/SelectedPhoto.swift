//
//  SelectedPhoto.swift
//  FlickR Search
//
//  Created by Giovanni Palusa on 2018-04-18.
//  Copyright © 2018 Giovanni Palusa. All rights reserved.
//

import UIKit

class SelectedPhoto: UIViewController {
    
    @IBOutlet weak var clearPhoto: UIImageView!
    @IBOutlet weak var blurredPhoto: UIImageView!
    
    var photo: Photos?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Unwrap photo url and download photo from Flickr
        if let photoURL = photo?.urlToPhoto as URL?{
            DataManager.downloadImage(url: photoURL) { (image) in
                self.clearPhoto.image = image
                self.blurredPhoto.image = image
            }
        }
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        if let image = clearPhoto.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            showPopup(message: "Image was successfully saved", code: 0, sender: self)
        }
    }
    
}
