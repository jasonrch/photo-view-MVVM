//
//  Constants.swift
//  PhotoVIewMVVM
//
//  Created by Julio Reyes on 6/18/19.
//  Copyright © 2019 Julio Reyes. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import Kingfisher

// MARK:  Typealiases
typealias PhotoDataRetrievalComplete = (_ results:PhotoSearch?,_ response: URLResponse?) -> ()
typealias ImageRetrievalComplete = (_ imageResource:RetrieveImageResult, Error?) -> ()

// MARK:  Notification keys
struct NotificationKeys{
    static let gotophotoDetail = "kPhotoDetailKey"
}

// MARK: Reuse identifiers
struct ReuseIdentifiers {
    static let segueIdentifier = "PhotoDetailSegueIdentifier"
    static let reuseIdentifier = "PhotoCollectionViewCellIdentifier"
}

// MARK: Extensions
// Implementation of MBProgressHUD via UIViewController extension
extension UIViewController {
    func showHUD(progressLabel:String){
        DispatchQueue.main.async{
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.mode = MBProgressHUDMode.indeterminate
            progressHUD.label.text = progressLabel
        }
    }
    
    func dismissHUD(isAnimated:Bool) {
        DispatchQueue.main.async{
            MBProgressHUD.hide(for: self.view, animated: isAnimated)
        }
    }
}
