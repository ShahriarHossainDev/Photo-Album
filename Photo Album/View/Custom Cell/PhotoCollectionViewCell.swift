//
//  PhotoCollectionViewCell.swift
//  Photo Album
//
//  Created by Shishir_Mac on 13/3/23.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    // MARK: Cell Configuration
    
    func configurateTheCell(_ photos: Photo) {
        photoImageView.image = UIImage(data: photos.imageData!)
    }
}
