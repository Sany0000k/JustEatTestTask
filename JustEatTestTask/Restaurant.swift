//
//  Restaurant.swift
//  JustEatTestTask
//
//  Created by Alexander Chulanov on 5/29/18.
//  Copyright © 2018 Alexander Chulanov. All rights reserved.
//

import Foundation
import SwiftGifOrigin

struct Restaurant {
	let name: String?
	let rating: String?
	let cuisineTypes: [String]?
	let logo: UIImage?
}

extension Restaurant {
    init(dictionary: [String: Any]) {
        name = dictionary["Name"] as? String
        rating = "\(dictionary["RatingAverage"]!)"
        var tempCuisineTypes = [String]()

        for cuisineType in (dictionary["CuisineTypes"] as? [[String: Any]])! {
            tempCuisineTypes.append(cuisineType["Name"] as! String)
        }

        cuisineTypes = tempCuisineTypes

        let logoURL = (dictionary["Logo"] as! [[String: String]])[0]["StandardResolutionURL"]
        logo = UIImage.gif(url: logoURL!)
    }

    static func restaurants(from listOfRestaurants: [[String: Any]]) -> [Restaurant] {
        var result = [Restaurant]()
        for restaurant in listOfRestaurants {
            result.append(Restaurant(dictionary: restaurant))
        }

        return result
    }
}
