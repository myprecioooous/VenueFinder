//
//  CityViewController.swift
//  FinalProject
//
//  Created by Precious Camille De Los Reyes on 11/20/19.
//  Copyright © 2019 Precious Camille De Los Reyes. All rights reserved.
//

import UIKit

class CityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var cityTableView: UITableView!
   
    let cities = [City(countryName: "Spain", cityName: "Barcelona", cityPhoto: "barcelona", cityLatitude: 41.3851, cityLongitude: 2.1734),
                  City(countryName: "Philippines", cityName: "Manila", cityPhoto: "manila", cityLatitude: 14.5995, cityLongitude: 120.9842) ,
                  City(countryName: "France", cityName: "Paris", cityPhoto: "paris", cityLatitude: 48.8566, cityLongitude: 2.3522),
                  City(countryName: "Korea", cityName: "Seoul", cityPhoto: "seoul", cityLatitude: 37.5665, cityLongitude: 126.9780),
                  City(countryName: "Japan", cityName: "Tokyo", cityPhoto: "tokyo", cityLatitude: 35.6762, cityLongitude: 139.6503)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        cityTableView.delegate = self
        cityTableView.dataSource = self
        
    }
    
    // MARK: - Delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 242
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityCell
        
        cell.countryNameLabel.text = cities[indexPath.row].countryName
        cell.cityNameLabel.text = cities[indexPath.row].cityName
        cell.cityPhoto.image = UIImage(named: cities[indexPath.row].cityPhoto)
        cell.cityPhoto.layer.cornerRadius = 10
        
        return cell
    }
    
    // MARK: - To pass data from ViewController to PersonViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //checking segue identifier
        if segue.identifier == "CityVCToVenueVC" {
            //specifying segue destination
            let venueVC = segue.destination as! VenueViewController
            
            //getting indexPath of selected tow
            if let indexPath = cityTableView.indexPathForSelectedRow {
                //passing latitude and longitude to the next view controller 
                venueVC.latitude = cities[indexPath.row].cityLatitude
                venueVC.longitude = cities[indexPath.row].cityLongitude
                venueVC.cityIndex = indexPath.row
            }
        }
    }

}
