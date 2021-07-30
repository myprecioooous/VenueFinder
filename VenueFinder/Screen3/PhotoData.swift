//
//  PhotoData.swift
//  FinalProject
//
//  Created by Precious Camille De Los Reyes on 7/30/21.
//  Copyright © 2021 Precious Camille De Los Reyes. All rights reserved.
//

import Foundation

struct PhotoData: Decodable {
    var response: Res
}

struct Res: Decodable {
    var photos: Photos
}

struct Photos: Decodable {
    var items: [Items]
}

struct Items: Decodable {
    var prefix: String
    var suffix: String
}
