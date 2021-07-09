//
//  VenueViewController.swift
//  FinalProject
//
//  Created by Precious Camille De Los Reyes on 11/20/19.
//  Copyright © 2019 Precious Camille De Los Reyes. All rights reserved.
//

import UIKit

class VenueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var venueTableView: UITableView!
    
    //jason result
    //index of what was clicked
    
    
    //MARK: - API STUFF
    //from previous screen
    var latitude: Double!
    var longitude: Double!
    
    let limit = 25
    
    let client_id = "HAHXS3GAZLAPTEQTUF4YEEBTWE2I321RTOVMWP0T5INAWKMU"
    let client_secret = "FZSHMITQCWQXKIJLZRUBQJMST1DU4H5KYI0GC4DY3MBMQFF5"
    
    let imageSize = "300x300"
    //var photoURL: String? = ""
    
    var searchResults = [JSON]()
    
    var cityIndex: Int!
    
    var favorites = [[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                     [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                     [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                     [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                     [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
                     
    ]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        venueTableView.delegate = self
        venueTableView.dataSource = self
        
        
        getVenueRecommendations()
        //saveFavorite()
        //checkForFavorite()
        //checkForFavorite()
        //loadInitialStateOfFavorites()
        
    }
    
    //MARK: Bookmarking
    
//    func loadInitialStateOfFavorites() {
//        for _ in 0..<limit {
//            favorites.append(false)
//        }
//    }
    
    @IBAction func starButtonTapped(_ sender: UIButton) {
        //checkForFavorite()
        
        //need to see which cell is tapped so we can change the value of hasFavorited appopritely
        let position: CGPoint = sender.convert(.zero, to: venueTableView)

        guard let indexPath = venueTableView.indexPathForRow(at: position) else { return }
        //print(indexPath.row)
        
        let hasFavoritedState = favorites[cityIndex][indexPath.row]
        
        //accessing has favorites and setting it's value
        favorites[cityIndex][indexPath.row] = !hasFavoritedState
        //saveFavorite()
        
        //reloading the row to change star color
        venueTableView.reloadRows(at: [indexPath], with: .fade)
        
    }
    
    //MARK: Saving
    func saveFavorite() {
        defaults.set(favorites, forKey: "favorites")
    }

    func checkForFavorite() {
        let favoriteArr = defaults.array(forKey: "favorites") as? [[Bool]] ?? [[Bool]]()
        //print(favoriteArr)

        favorites = favoriteArr
    }
    
    
    //MARK: For Printing purposes, will delete
    override func viewWillDisappear(_ animated: Bool) {
        //print(favorites)
    }
    
    //MARK: - Copied from Mr. Jitters
    func getVenueRecommendations() {
        let urlLatitude = latitude!
        let urlLongitude = longitude!
        
        let url = "https://api.foursquare.com/v2/search/recommendations?ll=\(urlLatitude),\(urlLongitude)&v=20191121&limit=\(limit)&client_id=\(client_id)&client_secret=\(client_secret)"
        
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, err -> Void in
            
            let json = JSON(data: data!)
            //print(json)
            self.searchResults = json["response"]["group"]["results"].arrayValue
                        
            DispatchQueue.main.async {
                self.venueTableView.isHidden = false
                self.venueTableView.reloadData()
            }
        })
        
        task.resume()
    }
    
    // MARK: - Required delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "venueCell", for: indexPath) as! VenueCell
        cell.venueNameLabel.text = searchResults[(indexPath as NSIndexPath).row]["venue"]["name"].string
        cell.venueLocationLabel.text = searchResults[(indexPath as NSIndexPath).row]["venue"]["location"]["address"].string
        cell.venueCategoryLabel.text = searchResults[(indexPath as NSIndexPath).row]["venue"]["categories"][0]["name"].string
        
        //MARK: Constructing an image url
        cell.thumbnailImage.image = UIImage(named: "gudetama")
        
        let prefix = searchResults[(indexPath as NSIndexPath).row]["photo"]["prefix"].string
        let suffix = searchResults[(indexPath as NSIndexPath).row]["photo"]["suffix"].string
        
        // MARK: - Retrieving image
        let imageURL = URL(string: (prefix ?? "NoVal") + imageSize + (suffix ?? "NoVal"))!
        
        //ask for the data
        let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            
            //check first if we have no error
            if error == nil {
                let loadingImage = UIImage(data: data!)

                //have to load UI stuff on the main thread
                DispatchQueue.main.async {
                    cell.thumbnailImage.image = loadingImage
                }
            }
        }

        //run task using resume
        task.resume()
    
        //cell.personLabel.text = persons[genderIndex][indexPath.row]
        
        if favorites[cityIndex][indexPath.row] == false {
            cell.starButton.tintColor = .lightGray
        } else {
            cell.starButton.tintColor = .red
        }
//
//        saveFavorite()
        //checkForFavorite()
        
        return cell
    }
    
    // MARK: - Additional delegate function
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // The cell's height
        return 150
    }
    
    // MARK: - To pass data from VenueViewController to PhotoViewController
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
           //checking segue identifier
           if segue.identifier == "VenueVCToPhotoVC" {
               //specifying segue destination
               let photoVC = segue.destination as! PhotoViewController
               
               //getting indexPath of selected tow
               if let venueIndexPath = venueTableView.indexPathForSelectedRow {
                
                let venueName = searchResults[venueIndexPath.row]["venue"]["name"].string                
                photoVC.json = searchResults
                photoVC.venueIndex = venueIndexPath.row
                photoVC.venueName = venueName ?? "No Name"
                photoVC.isBookMarked = favorites[cityIndex][venueIndexPath.row]
               }
           }
       }

}
