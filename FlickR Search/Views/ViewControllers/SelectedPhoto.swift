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
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Unwrap photo url and download photo from Flickr
        if let photoURL = photo?.urlToPhotoHigh as URL?{
            DataManager.downloadImage(url: photoURL) { (image) in
                
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                    self.infoLbl.isHidden = true
                    self.clearPhoto.image = image
                    self.blurredPhoto.image = image
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        spinner.isHidden = false
        spinner.startAnimating()
        infoLbl.isHidden = false
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        if let image = clearPhoto.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            showPopup(message: "Image was successfully saved", code: 999, sender: self)
        }
    }
    
}
