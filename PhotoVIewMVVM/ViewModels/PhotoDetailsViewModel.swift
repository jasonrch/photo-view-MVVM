//
//  PhotoDetailsViewModel.swift
//  PhotoVIewMVVM
//
//  Created by Julio Reyes on 6/18/19.
//  Copyright © 2019 Julio Reyes. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoDetailsViewModel: NSObject {
    
    private var element: PhotoSearchElement? {
        didSet{
            
        }
    }
    
    override init() {
        super.init()
    }
    
    func getElement(element: PhotoSearchElement){
        self.element = element
    }
    
    var imageTitle: String? {
        return element!.title
    }
    
    var imageURL: URL? {
        return URL(string: element!.url)
    }
    
    func getDetailImage(complete: @escaping ImageRetrievalComplete) {
        
        // Kingfisher implementation
        let url = URL(string: element!.url)
        KingfisherManager.shared.retrieveImage(with: url!) { result in
            
            // Pass the image resource through the block
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                complete(value, nil)
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
                complete(result.value!, error)
            }
            
        } // end result
    } // end getDetailImage
}
