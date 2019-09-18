//
//  PhotoDetailsViewController.swift
//  PhotoVIewMVVM
//
//  Created by Julio Reyes on 6/18/19.
//  Copyright © 2019 Julio Reyes. All rights reserved.
//

import UIKit
import Kingfisher
import MBProgressHUD

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet var photoDetailsViewModel: PhotoDetailsViewModel!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var photoTitle: UILabel! = {
        let label = UILabel()
        label.textColor = .red
        return label
    }()
    
    private lazy var options: KingfisherOptionsInfo = [
        .processor(RoundCornerImageProcessor(cornerRadius: 20)),
        .scaleFactor(UIScreen.main.scale),
        .cacheOriginalImage,
        .transition(.fade(0.2)),
        .backgroundDecode
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(String(describing: self.photoDetailsViewModel.imageURL))")
        
        // Do any additional setup after loading the view.
        setUpDetails()
    }
    
    func setUpDetails(){
        self.showHUD(progressLabel: "Loading...")
        
        // Get the image via ViewModel and set image.
        self.photoDetailsViewModel.getDetailImage { (imageResource, error) in
            self.photoImageView.kf.indicatorType = .activity
            self.photoImageView.kf.setImage(
                with: imageResource.source,
                placeholder: UIImage(named: "placeholderImage"),
                options: self.options)
            {
                result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
        }
        
        self.photoTitle.text = self.photoDetailsViewModel.imageTitle
        
        // Dismiss the Activity Indicator HUD
        self.dismissHUD(isAnimated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
