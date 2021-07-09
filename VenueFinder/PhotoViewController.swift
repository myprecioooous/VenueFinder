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
    
    
    let client_id = "HAHXS3GAZLAPTEQTUF4YEEBTWE2I321RTOVMWP0T5INAWKMU"
    let secret_id = "FZSHMITQCWQXKIJLZRUBQJMST1DU4H5KYI0GC4DY3MBMQFF5"
    
    //from previous screen
    var json: [JSON]!
    var venueIndex: Int!
    var venueName: String!
    
    var photoJson = [JSON]()
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
    
    var indexOfFavories = [Int]()
    var hasFavorited = false
    let defaults = UserDefaults.standard
    var isBookMarked: Bool!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
                
        getPhotos()
        //checkForFavorite()
    }
    
    //MARK: - For Printing purposes, will delete
    override func viewWillDisappear(_ animated: Bool) {
        //print(photoJson[0])
        //createPhotoURL()
        
        //print(photoJson.count)

    }
    
    //MARK: - Bookmarking
    @IBAction func starTapped(_ sender: UIButton) {
        print("favorite tapped")
        let tapped = !hasFavorited
        hasFavorited = tapped
        saveFavorite()

        collectionView.reloadData()



    }

    func saveFavorite() {
        defaults.set(hasFavorited, forKey: "favorite")
    }

    func checkForFavorite() {
        let isFavorite = defaults.bool(forKey: "favorite")

        if isFavorite {
           hasFavorited = true
        }
    }
    
    
    
    //MARK: Creating an array of photo url
    func createPhotoURL() {
         //print(photoJson.count)
        for index in 0..<photoJson.count {
            //print(photoJson[index])
            let prefix = photoJson[index]["prefix"].string
            let suffix = photoJson[index]["suffix"].string

            let imageURL = (prefix ?? "NoVal") + photoSize + (suffix ?? "NoVal")
            photoURL.append(imageURL)
        }
    }
    
    //MARK: Required delegate functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                
        //return photoJson.count
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        
        //MARK: Retrieving an image
        //cell.photoCellImage.image = UIImage(named: photos[indexPath.row])
        
        if photoJson.count > 0 {
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
        let vc = storyboard?.instantiateViewController(withIdentifier: "TestViewController") as? TestViewController
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    

    
    
    // MARK: - For implementing header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! PhotoHeaderView
        
        headerView.headerLabel.text = venueName
        
       if isBookMarked == true {
           headerView.starButton.tintColor = .red
       } else {
           headerView.starButton.tintColor = .lightGray
       }
        
        return headerView
    }
    
    
    
    // MARK: Getting venueID of the venue that was clicked
    func getVenueID() -> String {
        let unwrappedJson = json!
        let unwrappedVenueIndex = venueIndex!
        
        let venueID = unwrappedJson[unwrappedVenueIndex]["venue"]["id"].string
        
        return venueID!
        
    }
    
    // MARK: Getting photos based on venue ID
    func getPhotos() {
        let vID: String = getVenueID()
        
        let url = "https://api.foursquare.com/v2/venues/\(vID)/photos?&client_id=\(client_id)&client_secret=\(secret_id)&v=20191121"
        
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, err -> Void in
            
            let newJson = JSON(data: data!)
            //print(newJson)
            self.photoJson = newJson["response"]["photos"]["items"].arrayValue
            
            self.createPhotoURL()
            
        })
        
        task.resume()
    }
    

}
