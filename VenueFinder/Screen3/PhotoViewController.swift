//
//  PhotoViewController.swift
//  FinalProject
//
//  Created by Precious Camille De Los Reyes on 11/21/19.
//  Copyright © 2019 Precious Camille De Los Reyes. All rights reserved.
//

//https://api.foursquare.com/v2/search/recommendations?ll=14.5995,120.9842&v=20191121&limit=25&client_id=HAHXS3GAZLAPTEQTUF4YEEBTWE2I321RTOVMWP0T5INAWKMU&client_secret=FZSHMITQCWQXKIJLZRUBQJMST1DU4H5KYI0GC4DY3MBMQFF5


//works (venue id, seeing photo count)

        //https://api.foursquare.com/v2/venues/49eeaf08f964a52078681fe3?&client_id=HAHXS3GAZLAPTEQTUF4YEEBTWE2I321RTOVMWP0T5INAWKMU&client_secret=FZSHMITQCWQXKIJLZRUBQJMST1DU4H5KYI0GC4DY3MBMQFF5&v=20191121
        
        //retrived 1 photo
//  https://api.foursquare.com/v2/venues/4e226448fa761d671086f507/photos?&client_id=HAHXS3GAZLAPTEQTUF4YEEBTWE2I321RTOVMWP0T5INAWKMU&client_secret=FZSHMITQCWQXKIJLZRUBQJMST1DU4H5KYI0GC4DY3MBMQFF5&v=20191121

import UIKit

class PhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //TODO: - Get venueID and get photos

    @IBOutlet weak var collectionView: UICollectionView!
    
    //from previous screen
    var json: [Results]!
    var venueIndex: Int!
    var venueName: String!
    
    var photoJson = [Items]()
    var sampleURL = ["https://i.kym-cdn.com/photos/images/original/001/157/126/1f8", "https://i.kym-cdn.com/photos/images/original/001/157/120/c21.jpg", "https://i.kym-cdn.com/photos/images/original/001/157/124/459.png", "https://i.kym-cdn.com/photos/images/original/001/157/161/88b.jpg", "https://i.kym-cdn.com/photos/images/original/001/157/163/9c3.jpg", "https://i.kym-cdn.com/photos/images/original/001/157/160/d2c.jpg"]
    
    var photoURL = [String]() {
        didSet {
            //updating the UI so we have to do this on the main thread
            DispatchQueue.main.async {
                //since we're calling reload data on the collectionview, it means the data source functions are going to be called
                self.collectionView.reloadData()
                
            }
            
        }
    }
    var photoSize = "300x300"
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //adjust to width of the screen so photos fill the area accordingly
        //access width of screen
        let itemSize = UIScreen.main.bounds.width/3 - 3
        
        //create a new layout that's going to override current layout
        let layout = UICollectionViewFlowLayout()
        
        //define size of each image
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        //space between photos
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        
        //add layout to our collection view
        //collectionView.frame = .zero
        collectionView.collectionViewLayout = layout
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        fetchPhotosForVenue()
        //checkForFavorite()
    }
    
    //MARK: - Helper functions
    
    //Getting venueID of the venue that was clicked
    func getVenueID() -> String {
        let unwrappedJson = json!
        let unwrappedVenueIndex = venueIndex!
        
        let venueID = unwrappedJson[unwrappedVenueIndex].venue.id
        
        return venueID
        
    }
    
    //Getting photos based on venue ID
    func fetchPhotosForVenue() {
        let vID: String = getVenueID()
        
        VenueAPI.sharedInstance.getPhotos(vID) { [weak self] (data, error) in
            //print(venueData ?? "")
            self?.photoJson = data?.response.photos.items ?? []
            self?.createPhotoURL()
        }
        
    }
    
    //Creating an array of photo url
    func createPhotoURL() {
         //print(photoJson.count)
        for index in 0..<photoJson.count {
            //print(photoJson[index])
            let prefix = photoJson[index].prefix
            let suffix = photoJson[index].suffix

            let imageURL = (prefix ?? "NoVal") + photoSize + (suffix ?? "NoVal")
            photoURL.append(imageURL)
        }
        
        photoURL = photoURL + sampleURL + sampleURL + sampleURL
        
        print("photo url contains: \(photoURL)" )
        
    }
    
    //MARK: Delegate functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                
        //return photoJson.count
        return photoURL.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        
        //Retrieving an image
        if photoURL.count > 0 {
            let url = NSURL(string: self.photoURL[indexPath.row])
            let data = NSData(contentsOf: url! as URL)
            cell.photoCellImage.image = UIImage(data: data! as Data)
        } else {
            cell.photoCellImage.image = UIImage(named: "gudetama")
        }
        
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        
        
        return cell
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "TestViewController") as? TestViewController
//        
//        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    // MARK: - Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! PhotoHeaderView
        
        headerView.headerLabel.text = venueName
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
     }
    
}
