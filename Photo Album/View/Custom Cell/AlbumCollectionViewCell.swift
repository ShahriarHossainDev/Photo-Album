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
    @IBOutlet weak var minButton: UIButton!
    
    var deleteThisCell: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        albumImageView.layer.cornerRadius = 5.0
        albumTitleLabel.text = nil
        photoNumberLabel.text = nil
        minButton.dropShadow()
    
        // Initialization code
    }

    override func prepareForReuse() {
        albumImageView.image = UIImage(named: "placeholder")
        minButton.isHidden = true
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        deleteThisCell?()
    }
    // MARK: Cell Configuration
    
    func configurateTheCell(_ albums: Album) {
        albumTitleLabel.text = albums.title
    }
}
