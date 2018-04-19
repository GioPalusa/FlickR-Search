//
//  Photos.swift
//  FlickR Search
//
//  Created by Giovanni Palusa on 2018-04-18.
//  Copyright © 2018 Giovanni Palusa. All rights reserved.
//

import Foundation

struct Photo {
    
    let title: String
    let secret: String
    let photoId: String
    let farm: Int
    let server: String
    let owner: String
    
    var urlToPhotoMedium: NSURL {
        return NSURL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_m.jpg")!
    }
    
    var urlToPhotoHigh: NSURL {
        return NSURL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_h.jpg")!
    }
    
}
