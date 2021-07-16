//
//  Model.swift
//  FintecimalTest
//
//  Created by Jerry Lozano on 5/11/21.
//

import UIKit

struct Model {
    enum CodingKeys {
        case streetName
        case suburbPlace
        case fVisited
        case fLocation
    }
    
    let id = UUID()
    let streetName: String?
    let suburbPlace: String?
    let fVisited: Bool?
    let fLocation: CustomLocation?
}

struct CustomLocation: Codable {
    enum CodingKeys: CodingKey {
        case latitude
        case longitude
    }
    
    let latitude: Double
    let longitude: Double
}
