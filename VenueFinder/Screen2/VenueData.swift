//
//  Venue.swift
//  FinalProject
//
//  Created by Precious Camille De Los Reyes on 12/9/19.
//  Copyright © 2019 Precious Camille De Los Reyes. All rights reserved.
//


import Foundation

struct VenueData: Decodable {
    var response: Response
}


struct Response: Decodable {
    var group: Group
}

struct Group: Decodable {
    var results: [Results]
}

struct Results: Decodable {
    var venue: Venue
    var photo: Photo?
}

struct Venue: Decodable {
    var id: String
    var name: String
    var location: Location
    var categories: [Category]
    
}

struct Photo: Decodable {
    var prefix: String
    var suffix: String
}

struct Location: Decodable {
    var address: String?
}

struct Category: Decodable {
    var id: String
    var name: String
    var icon: Icon
}

struct Icon: Decodable {
    var prefix: String
    var suffix: String
}

