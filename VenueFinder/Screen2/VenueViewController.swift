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
    
    
    //MARK: - Initialization
    //from previous screen
    var latitude: Double!
    var longitude: Double!
    
    let imageSize = "300x300"
    
    var searchResults = [Results]()
    
    var cityIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        venueTableView.delegate = self
        venueTableView.dataSource = self
        
        fetchVenueForLocation()
        
    }
    
    //Fetching venue recommendations
    func fetchVenueForLocation(){
        VenueAPI.sharedInstance.getVenueRecommendations(latitude,longitude) { [weak self] (venueData, error) in
            //print(venueData ?? "")
            if error == nil {
                self?.searchResults = venueData?.response.group.results ?? []
            }
            
            DispatchQueue.main.async {
                self?.venueTableView.isHidden = false
                self?.venueTableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "venueCell", for: indexPath) as! VenueCell
        cell.venueNameLabel.text = searchResults[(indexPath as NSIndexPath).row].venue.name
        cell.venueLocationLabel.text = searchResults[(indexPath as NSIndexPath).row].venue.location.address
        cell.venueCategoryLabel.text = searchResults[(indexPath as NSIndexPath).row].venue.categories[0].name
        
        //MARK: Constructing an image url
        cell.thumbnailImage.image = UIImage(named: "gudetama")
        
        let prefix = searchResults[(indexPath as NSIndexPath).row].photo?.prefix
        let suffix = searchResults[(indexPath as NSIndexPath).row].photo?.suffix
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // The cell's height
        return 150
    }
    
    // MARK: - Pass data from VenueViewController to PhotoViewController
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
           //checking segue identifier
           if segue.identifier == "VenueVCToPhotoVC" {
               //specifying segue destination
               let photoVC = segue.destination as! PhotoViewController
               
               //getting indexPath of selected tow
               if let venueIndexPath = venueTableView.indexPathForSelectedRow {
                
                let venueName = searchResults[venueIndexPath.row].venue.name
                photoVC.json = searchResults
                photoVC.venueIndex = venueIndexPath.row
                photoVC.venueName = venueName ?? "No Name"
                //photoVC.isBookMarked = favorites[cityIndex][venueIndexPath.row]
               }
           }
       }

}
