//
//  AlbumCollectionViewCell.swift
//  Photo Album
//
//  Created by Shishir_Mac on 13/3/23.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var photoNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        albumImageView.layer.cornerRadius = 5.0
        // Initialization code
    }

    override func prepareForReuse() {
        albumImageView.image = UIImage(named: "placeholder")
    }
}
