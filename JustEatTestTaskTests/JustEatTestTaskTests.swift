//
//  JustEatTestTaskTests.swift
//  JustEatTestTaskTests
//
//  Created by Alexander Chulanov on 5/29/18.
//  Copyright © 2018 Alexander Chulanov. All rights reserved.
//

import XCTest
@testable import JustEatTestTask

class JustEatTestTaskTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRestaurantConstructor() {
		
		var restaurantDictionary: NSDictionary?
		let path = Bundle(for: JustEatTestTaskTests.self).path(forResource: "RestaurantTest", ofType: "plist")
		restaurantDictionary = NSDictionary(contentsOfFile: path!)
		
		let restaurant = Restaurant(dictionary: restaurantDictionary as! [String : Any])
		
		assert(restaurant.name == "Mario's", "wrong name parsing")
		assert(restaurant.rating == "4", "wrong rating parsing")
		assert(restaurant.cuisineTypes! == ["pizza", "Italian"], "wrong cuisineTypes parsing")
		
    }
	
	func testRestaurantFactory() {
		let request = RequestFactory.getRestarauntsRequest(postcode: "se19")
		
		assert(request?.url?.absoluteString == "https://public.je-apis.com/restaurants?q=se19",
			   "wrong request url")
		assert(request?.allHTTPHeaderFields!["Accept-Tenant"] == "uk",
			   "wrong Accept-Tenant header value")
		assert(request?.allHTTPHeaderFields!["Accept-Language"] == "en-GB",
			   "wrong Accept-Language header value")
		assert(request?.allHTTPHeaderFields!["Authorization"] == "Basic VGVjaFRlc3Q6bkQ2NGxXVnZreDVw",
			   "wrong Authorization header value")
		assert(request?.allHTTPHeaderFields!["Host"] == "public.je-apis.com",
			   "wrong Host header value")
	}
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
