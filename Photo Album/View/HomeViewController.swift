//
//  HomeViewController.swift
//  Photo Album
//
//  Created by Shishir_Mac on 13/3/23.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var addAlbumButton: UIButton!
    
    weak var actionToEnableSave: UIAlertAction?
    
    private let cellIdentifier: String = "albumCell"
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items: [Album]?
    
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.albumCollectionView.register(UINib(nibName: "AlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        
        addAlbumButton.dropShadow()
        
        fetchAlbum()
    }
    
    // MARK: - Function
    
    // fetch core data
    func fetchAlbum() {
        
        do {
            let request = Album.fetchRequest() as NSFetchRequest<Album>
            self.items = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.albumCollectionView.reloadData()
            }
            
        } catch let error{
            print(error.localizedDescription)
        }
        
    }
    
    // MARK: - Button Action
    @IBAction func addAlbumButtonAction(_ sender: UIButton) {
        let actionController = UIAlertController(title: "New Album", message : "Enter a name for this album", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (action) -> Void in
            if actionController.textFields![0].text == "" {
                
            } else {
                
                let newAlbum = Album(context: self.context)
                newAlbum.title = actionController.textFields![0].text
                do {
                    try self.context.save()
                } catch let error{
                    print(error.localizedDescription)
                }
                self.fetchAlbum()
            }
            
        } )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        actionController.addTextField { textField -> Void in
            textField.placeholder = "Title"
            textField.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
        }
        
        actionController.addAction(saveAction)
        actionController.addAction(cancelAction)
        
        // Save button isEnabled to false
        self.actionToEnableSave = saveAction
        saveAction.isEnabled = false
        
        self.present(actionController, animated: true, completion: nil)
    
    }
    
    @objc func textDidChange(_ sender: UITextField) {
        // Save button isEnabled to true
        self.actionToEnableSave?.isEnabled = !sender.text!.isEmpty
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AlbumCollectionViewCell {
            cell.configurateTheCell(items![indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "inPhotoView", sender: items![indexPath.row])
    }
    
}
