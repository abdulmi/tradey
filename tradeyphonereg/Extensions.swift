//
//  Extensions.swift
//  tradeyphonereg
//
//  Created by Abdulqader Almetwali on 2016-07-09.
//  Copyright © 2016 abdul. All rights reserved.
//

import UIKit

let imageCache = NSCache()

extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        //check cache for image first 
        if let chachedImage = imageCache.objectForKey(urlString) as? UIImage {
            print("getting photo from cahce")
            self.image = chachedImage
            return
        }
        
        //otherwise get it from firebase
        let url = NSURL(string: urlString)
        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
            if(error != nil) {
                print(error)
                return
            }
            print("getting photo from firebase")
            dispatch_async(dispatch_get_main_queue(), {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString)
                    self.image = downloadedImage
                }
            })
            
        }).resume()

    }
}