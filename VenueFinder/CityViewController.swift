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
   
    let cities = [City(cityName: "Barcelona", cityLatitude: 41.3851, cityLongitude: 2.1734),
                  City(cityName: "Manila", cityLatitude: 14.5995, cityLongitude: 120.9842) ,
                  City(cityName: "Paris", cityLatitude: 48.8566, cityLongitude: 2.3522),
                  City(cityName: "Seoul", cityLatitude: 37.5665, cityLongitude: 126.9780),
                  City(cityName: "Tokyo", cityLatitude: 35.6762, cityLongitude: 139.6503)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        cityTableView.delegate = self
        cityTableView.dataSource = self
        
    }
    
    // MARK: - Required delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityCell
        
        cell.cityNameLabel.text = cities[indexPath.row].cityName
        //cell.cityNameLabel.text = cities[indexPath.row]
        
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
