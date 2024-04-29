//
//  UIImageViewExtension.swift
//  GithubMobile
//
//  Created by dearboy on 2024/04/29.
//

import UIKit

let imageCache = NSCache<NSString,AnyObject>()

extension UIImageView {
    func loadImage(url urlString: String) {

        let url = URL(string: urlString)
        guard url != nil else { return }
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
                
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil || data == nil {
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
                
            }
        }.resume()
    }
}
