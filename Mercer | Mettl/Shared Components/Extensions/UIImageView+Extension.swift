//
//  UIImageView+Extension.swift
//  Mercer | Mettl
//
//  Created by m@k on 10/03/22.
//

import UIKit

extension UIImageView {
    func addBorder(_ color:UIColor, _ cornerRadius: CGFloat = 0.0) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
  /*  func downloadImage(from url:String, with defaultImage:UIImage?) {
        guard let _ = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            if defaultImage != nil {
                self.image = defaultImage
                self.contentMode = .scaleAspectFit
            } else {
                self.image = nil
            }
            return
        }
        
        let imageURL = URL.init(string: url)
        self.sd_setImage(with: imageURL) { (image, error, _, _) in
            if error != nil {
                self.image = defaultImage
                self.contentMode = .scaleAspectFit
            } else {
                self.image = image
                self.contentMode = .scaleAspectFill
            }
        }
    }
    func setImageFromURL(_ url:String, with defaultImage:UIImage?) {
        if url.contains("no_image") {
            self.image = defaultImage
            self.contentMode = .scaleAspectFit
            return
        }
        
        let imageLink = url
        guard let urlImage = imageLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            if defaultImage != nil {
                self.image = defaultImage
                self.contentMode = .scaleAspectFit
            } else {
                self.image = nil
            }
            return
        }
        
        let imageURL = URL.init(string: urlImage)
        self.sd_setImage(with: imageURL) { (image, error, _, _) in
            if error != nil {
                self.image = defaultImage
                self.contentMode = .scaleAspectFit
            } else {
                self.image = image
                self.contentMode = .scaleAspectFill
            }
        }
    }
    
    func downloadImageFrom(urlString: String, with placeHolder:UIImage) {
        
        let url = URL(string: urlString)
        self.image = nil
        // check for the cached image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        self.image = placeHolder
        // otherwise cache the images to decrease the use of internet, new download of the image will be done
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error as Any)
                DispatchQueue.main.async {
                    self.image = UIImage(named: "defaultUser-Male")
                }
                return
            }
            // downloaded the images succesfully
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            }
        }.resume()
    }*/
}
