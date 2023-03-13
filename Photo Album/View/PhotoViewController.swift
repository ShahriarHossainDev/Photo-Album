//
//  PhotoViewController.swift
//  Photo Album
//
//  Created by Shishir_Mac on 13/3/23.
//

import UIKit
import PhotosUI

class PhotoViewController: UIViewController {
    
    var imageArray = [UIImage]()
    
    private let cellIdentifier: String = "photoCell"
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var tabPhotoView: UIView!
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoCollectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)

        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        addPhotoButton.dropShadow()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPhotoButtonAction(_ sender: UIButton) {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0
        
        let pickerVC = PHPickerViewController(configuration: config)
        pickerVC.delegate = self
        self.present(pickerVC, animated: true)
    }
    
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PhotoCollectionViewCell {
            cell.photoImageView.image = imageArray[indexPath.row]
            return cell
        }
        
        return UICollectionViewCell()
    }

}

// MARK: - PHPickerViewControllerDelegate
extension PhotoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    self.imageArray.append(image)
                }
                
                DispatchQueue.main.async {
                    self.photoCollectionView.reloadData()
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 4 - 1, height: collectionView.frame.size.height / 8 - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
