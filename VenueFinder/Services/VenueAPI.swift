//
//  VenueAPI.swift
//  FinalProject
//
//  Created by Precious Camille De Los Reyes on 7/14/21.
//  Copyright © 2021 Precious Camille De Los Reyes. All rights reserved.
//

import Foundation

enum DataError: Error {
  case invalidResponse
  case noData
  case failedRequest
  case invalidData
}

class VenueAPI {
    
    typealias VenueDataCompletion = (VenueData?, DataError?) -> ()
    typealias VenuePhotoCompletion = (PhotoData?, DataError?) -> ()
    static let sharedInstance = VenueAPI()
    
    let limit = 25

    let client_id = "HAHXS3GAZLAPTEQTUF4YEEBTWE2I321RTOVMWP0T5INAWKMU"
    let client_secret = "FZSHMITQCWQXKIJLZRUBQJMST1DU4H5KYI0GC4DY3MBMQFF5"
    
    func getVenueRecommendations(_ latitude: Double?, _ longitude: Double?, completion: @escaping VenueDataCompletion) {
        let urlLatitude = latitude!
        let urlLongitude = longitude!
        
        let url = "https://api.foursquare.com/v2/search/recommendations?ll=\(urlLatitude),\(urlLongitude)&v=20191121&limit=\(limit)&client_id=\(client_id)&client_secret=\(client_secret)"
        
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            
            
            //FIX: - Will fix later 
            guard error == nil else {
              print("Failed request from API: \(error!.localizedDescription)")
              completion(nil, .failedRequest)
              return
            }
            
            guard let data = data else {
              print("No data returned from API")
              completion(nil, .noData)
              return
            }
            
            guard (response as? HTTPURLResponse) != nil else {
              print("Unable to process API response")
              completion(nil, .invalidResponse)
              return
            }
            
            
            do {
              let decoder = JSONDecoder()
                let venueData: VenueData = try decoder.decode(VenueData.self, from: data)

              completion(venueData, nil)
            } catch {
              print("Unable to decode Venue response: \(error.localizedDescription)")
              completion(nil, .invalidData)
            }
            
        })
        
        task.resume()
    }
    
    func getPhotos(_ venueID: String, completion: @escaping VenuePhotoCompletion) {
        
        let url = "https://api.foursquare.com/v2/venues/\(venueID)/photos?&client_id=\(client_id)&client_secret=\(client_secret)&v=20191121"
        
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, err -> Void in
            
            guard let data = data else {
              print("No data returned from API")
              completion(nil, .noData)
              return
            }
            
            do {
              let decoder = JSONDecoder()
                let newData: PhotoData = try decoder.decode(PhotoData.self, from: data)

              completion(newData, nil)
            } catch {
              print("Unable to decode Venue response: \(error.localizedDescription)")
              completion(nil, .invalidData)
            }
            
        })
        
        task.resume()
    }
}


