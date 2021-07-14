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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        venueTableView.delegate = self
        venueTableView.dataSource = self
        
        
        getVenueRecommendations()
        
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
                //photoVC.isBookMarked = favorites[cityIndex][venueIndexPath.row]
               }
           }
       }

}
