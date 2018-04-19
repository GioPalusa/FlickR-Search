//
//  Datamanager.swift
//  FlickR Search
//
//  Created by Giovanni Palusa on 2018-04-18.
//  Copyright © 2018 Giovanni Palusa. All rights reserved.
//

import UIKit

class DataManager {
    
    struct Keys {
        fileprivate let key = "3b7ada2841751064f7797b9688ccaecd"
        fileprivate let secret = "f5100e10c9716089"
    }
    
    
    class func getPhotosFromFlickr(keywords: String, completion: @escaping (_ photos: [Photos]?, _ error: NSError?) -> ()) {
        let escapedSearchText: String = keywords.addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
        let urlString: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Keys().key)&tags=\(escapedSearchText)&per_page=100&format=json&nojsoncallback=1"
        let url: NSURL = NSURL(string: urlString)!
        let searchTask = URLSession.shared.dataTask(with: url as URL, completionHandler: {data, response, error -> Void in
            
            if error != nil {
                completion(nil, error as NSError?)
                return
            }
            
            do {
                let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                guard let results = resultsDictionary else { return }
                
                if let statusCode = results["code"] as? Int {
                    returnErrorMessage(errorCode: statusCode, completion: { (message) in
                        let invalidAccessError = NSError(domain: "com.flickr.api", code: statusCode, userInfo: ["message":message])
                        completion(nil, invalidAccessError)
                    })
                    return
                }
                
                guard let photosContainer = resultsDictionary!["photos"] as? NSDictionary else { return }
                guard let photosArray = photosContainer["photo"] as? [NSDictionary] else { return }
                
                let photosFromFlickr: [Photos] = photosArray.map { photoDictionary in
                    
                    let photoId = photoDictionary["id"] as? String ?? ""
                    let farm = photoDictionary["farm"] as? Int ?? 0
                    let secret = photoDictionary["secret"] as? String ?? ""
                    let server = photoDictionary["server"] as? String ?? ""
                    let title = photoDictionary["title"] as? String ?? ""
                    let owner = photoDictionary["owner"] as? String ?? ""
                    
                    
                    let flickrPhoto = Photos(title: title, secret: secret, photoId: photoId, farm: farm, server: server, owner: owner)
                    return flickrPhoto
                }
                
                completion(photosFromFlickr, nil)
                
            } catch let error as NSError {
                print("Error parsing JSON: \(error)")
                completion(nil, error)
                return
            }
            
        })
        searchTask.resume()
    }
    
    class func getImageFromURL(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    class func downloadImage(url: URL, completion: @escaping (_ image: UIImage?) -> Void) {
        DataManager.getImageFromURL(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                completion(UIImage(data: data))
            }
        }
    }
    
    // MARK: - Error messages
    
    // Returns texts written by FlickR to explain why the error occured
    class func returnErrorMessage(errorCode: Int, completion: @escaping (_ message: String) -> ()) {
        
        switch errorCode {
        case 1:
            completion("Too many tags in ALL query")
        case 10:
            completion("Sorry, the Flickr search API is not currently available.")
        case 11:
            completion("No valid machine tags. The query styntax for the machine_tags argument did not validate.")
        case 12:
            completion("The maximum number of machine tags in a single query was exceeded.")
        case 100:
            completion("Invalid API Key")
        case 116:
            completion("Bad URL found")
        default:
            completion("Unknown error")
        }
        
    }
    
}
