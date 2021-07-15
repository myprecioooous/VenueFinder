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
    
    typealias VenueDataCompletion = (JSON?, DataError?) -> ()
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
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, err -> Void in
            
            let json = JSON(data: data!)
            completion(json, nil)
        })
        
        task.resume()
    }
}


