//
//  PhotoCollectionViewModel.swift
//  PhotoVIewMVVM
//
//  Created by Julio Reyes on 6/18/19.
//  Copyright © 2019 Julio Reyes. All rights reserved.
//

import UIKit

class PhotoCollectionViewModel: NSObject {
    // Declare and initialize variables
    private var apiClient: APIClientService!
    
    private var photoResultModel: PhotoSearch? = nil
    {
        didSet {
            self.reloadCollectionViewCompletion?()
        }
    }
    
    
    // Check if the API Service is making a network call
    var isLoading: Bool = false {
        didSet{
            self.loadingStatus?()
        }
    }
    
    var reloadCollectionViewCompletion: ( () -> () )?
    var loadingStatus: ( () -> () )?
    
    override init() {
        super.init()
        self.apiClient = APIClientService()
    }
    
    // Booststrap function in order to make network call within the scope of the view model
    func photoSearchBootstrap(){
        self.getPhotos()
    }
    
    
    // Private network call for getting the Photos. Minimizes access control for calls as possible in order not to manipulate the view model excessively
    private func getPhotos(){
        self.isLoading = true // Network call is being made.
        try! apiClient.downloadSearchResultsForPhotos(complete: { (photo, response) in
            self.photoResultModel = photo
            self.isLoading = false // Network call is complete.
        }, failure: { (err) in
            self.photoResultModel = nil
            self.isLoading = false // Network call is complete.
        })
    }
}

// MARK: Extensions
extension PhotoCollectionViewModel {
    func currentAlbumID(at indexPath: IndexPath) -> Int {
        return (photoResultModel?[indexPath.row].albumID)!
    }
    
    func currentElement(at indexPath: IndexPath) -> PhotoSearchElement{
        return photoResultModel![indexPath.row]
    }
}

// MARK: UICollectionView Data Source
extension PhotoCollectionViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoResultModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        let element = photoResultModel![indexPath.row]
        cell.photoElement = element // Cell will be configured once this element is set
        return cell
    }
}

// MARK: UICollectionView Delegate
extension PhotoCollectionViewModel: UICollectionViewDelegate {
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){

    }
}
