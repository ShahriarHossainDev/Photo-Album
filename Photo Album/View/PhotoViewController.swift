//
//  PhotoViewController.swift
//  Photo Album
//
//  Created by Shishir_Mac on 13/3/23.
//

import UIKit
import PhotosUI
import CoreData

class PhotoViewController: UIViewController {
    
    var imageArray = [UIImage]()
    var selectedImage: UIImage?
    public var selectedAlbum: String = String()
    var photos: [Photo]?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        
        featchPhoto()
        
    }
    
    // MARK: - Function
    func featchPhoto() {
        do {
            let request = Photo.fetchRequest() as NSFetchRequest<Photo>
            self.photos = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.photoCollectionView.reloadData()
            }
        } catch let error{
            print(error.localizedDescription)
        }
    }
    
    // core Data Object From Images
    func coreDataObjectFromImages(images: [UIImage]) -> Data? {
        let dataArray = NSMutableArray()
        
        for img in images {
            if let data = img.pngData() {
                dataArray.add(data)
            }
        }
        
        return try? NSKeyedArchiver.archivedData(withRootObject: dataArray, requiringSecureCoding: true)
    }

    // images From CoreData
    func imagesFromCoreData(object: Data?) -> [UIImage]? {
        var retVal = [UIImage]()

        guard let object = object else { return nil }
        if let dataArray = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: object) {
            for data in dataArray {
                if let data = data as? Data, let image = UIImage(data: data) {
                    retVal.append(image)
                }
            }
        }
        
        return retVal
    }
    
    // MARK: - IBAction
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PhotoCollectionViewCell {
            
            if let image = UIImage(data: photos![indexPath.item].imageData!) {
                cell.photoImageView.image = image
                cell.photoImageView.image = imageArray[indexPath.row]
            }
            
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
            result.itemProvider.loadObject(ofClass: UIImage.self) { [self] object, error in
                if let image = object as? UIImage {
                    self.imageArray.append(image)
                    let pro = Photo(context: self.context)
                    pro.imageData = coreDataObjectFromImages(images: imageArray)
                    
                    // Data Relationship
                    let albums = Album(context: self.context)
                    albums.addToPhotos(pro)
                    
                    DispatchQueue.main.async {
                        do {
                            try self.context.save()
                        } catch let error{
                            print(error.localizedDescription)
                        }
                    }
                    
                    self.featchPhoto()
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
