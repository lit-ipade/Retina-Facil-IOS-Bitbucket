//
//  CollectionViewGalleryController.swift
//  AppOftamologia
//
//  Created by Felipe Martins on 09/01/2018.
//  Copyright © 2018 Felipe Martins. All rights reserved.
//

import Foundation
import INSPhotoGallery

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectionIndicator: UIImageView!
    
    
    func populateWithPhoto(_ photo: INSPhotoViewable) {
        photo.loadThumbnailImageWithCompletionHandler { [weak photo] (image, error) in
            if let image = image {
                if let photo = photo as? INSPhoto {
                    photo.thumbnailImage = image
                }
                self.imageView.image = image
            }
        }
    }
}
