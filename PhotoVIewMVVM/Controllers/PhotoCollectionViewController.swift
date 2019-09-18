//
//  PhotoCollectionViewController.swift
//  PhotoVIewMVVM
//
//  Created by Julio Reyes on 6/18/19.
//  Copyright © 2019 Julio Reyes. All rights reserved.
//

import UIKit
import MBProgressHUD


class PhotoCollectionViewController: UICollectionViewController {
    
    // TODO: SET UP VIEW MODEL VIA DEPENDENCY INJECTION THROUGH STORYBOARD
    @IBOutlet private var photoViewModel: PhotoCollectionViewModel? = PhotoCollectionViewModel()
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the data source and delegate to bind through the view model
        self.collectionView.dataSource = self.photoViewModel
        self.collectionView.delegate = self.photoViewModel
        
        // Do any additional setup after loading the view.
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.tintColor = UIColor(red: 0.83, green: 0.13, blue: 0.50, alpha: 1.0)
        refreshControl.addTarget(self, action: #selector(setUpCollectionView), for: .valueChanged)
        self.collectionView.addSubview(refreshControl)
        
        setUpCollectionView()
    }
    
    // MARK: Set up Collection View
    @objc func setUpCollectionView() {
        // Set up reload data binding to reload the collection view whenever the view model is changed.
        // This is needed for most of the Data sourcing is done in a background thread.
        self.photoViewModel!.reloadCollectionViewCompletion = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        // Set up loading status binding to do checks on whether data is being processed.
        // This is good if you wish to any UI setups beforehand.
        self.photoViewModel!.loadingStatus = { [weak self] in
            DispatchQueue.main.async {
                // MBProgressHUD setup
                let isLoading = self?.photoViewModel?.isLoading ?? false
                if isLoading{
                    self?.showHUD(progressLabel: "Loading...")
                }else{
                    self?.dismissHUD(isAnimated: true)
                    if self!.refreshControl.isRefreshing {
                        self?.perform(#selector(self?.refreshComplete), with: nil, afterDelay: 3.0)
                    }
                }
            }
        }
        // Bootstrap the private network call to get the photos
        self.photoViewModel!.photoSearchBootstrap()
        

    }
    
    @objc func refreshComplete() {
        refreshControl.endRefreshing()
    }


    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == ReuseIdentifiers.segueIdentifier{
                if let detailsVC = segue.destination as? PhotoDetailsViewController{
                    if let indexPath = self.collectionView.indexPathsForSelectedItems?.first{
                        print("\((self.photoViewModel?.currentElement(at: indexPath))!)")
                        detailsVC.photoDetailsViewModel.getElement(element: (self.photoViewModel?.currentElement(at: indexPath))!)
                    }
                }
            }
    }
}
