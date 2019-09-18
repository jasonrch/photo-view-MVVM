//
//  PhotoCollectionViewCell.swift
//  PhotoVIewMVVM
//
//  Created by Julio Reyes on 6/18/19.
//  Copyright © 2019 Julio Reyes. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

let cache = ImageCache.default

class PhotoCollectionViewCell: UICollectionViewCell {
    
    var photoElement: PhotoSearchElement?{
        didSet{
            configureCell() // Set the cell parameters once the variable has been set
        }
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    private lazy var options: KingfisherOptionsInfo = [
        .processor(DownsamplingImageProcessor(size: photoImageView.frame.size)),
        .scaleFactor(UIScreen.main.scale),
        .cacheOriginalImage,
        .transition(.fade(0.2)),
        .backgroundDecode
    ]
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.kf.cancelDownloadTask()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    private func configureCell() {
        //Initialize the image view
        photoImageView.image = nil
        
        //Obtain the URL string in order to create the image resource
        let thumbnailURLString: String = photoElement!.thumbnailURL
        guard let thumbnailURL = URL(string: thumbnailURLString) else { return }
        
        // Create Image Resource to cache via Kingfisher image library.
        let imageResource = ImageResource(downloadURL: thumbnailURL, cacheKey: thumbnailURLString)
        
        // Check if image is cached. If so, obtain the image via cache. If not, download and set up the image via .kf(KingfisherWrapper)
        let cached = cache.isCached(forKey: imageResource.cacheKey)
        if cached{
            cache.retrieveImage(forKey: imageResource.cacheKey) { result in
                switch result {
                    case .success(let value):
                        print(value.cacheType)
                        
                        // If the `cacheType is `.none`, `image` will be `nil`.
                        print(value.image!)
                        DispatchQueue.main.async { self.photoImageView.image = value.image }
                    case .failure(let error):
                        print(error)
                }
            }
        } else {
            self.photoImageView.kf.setImage(with: imageResource, options: self.options)  { result in
                // `result` is either a `.success(RetrieveImageResult)` or a `.failure(KingfisherError)`
                switch result {
                case .success(let value):
                    // The image was set to image view:
                    print(value.image)
                    
                    // From where the image was retrieved:
                    // - .none - Just downloaded.
                    // - .memory - Got from memory cache.
                    // - .disk - Got from disk cache.
                    print(value.cacheType)
                    
                    // The source object which contains information like `url`.
                    print(value.source)
                    
                case .failure(let error):
                    print(error) // The error happens
                }
            }
        }
    }
}


