//
//  RestaurantsListController.swift
//  JustEatTestTask
//
//  Created by Alexander Chulanov on 5/29/18.
//  Copyright © 2018 Alexander Chulanov. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

public class RestaurantsListController: UIViewController {
	
	enum Constants {
		static let restaurantCellID = "restaurantCellID"
	}
	
	@IBOutlet weak var tableView: UITableView?
	@IBOutlet weak var refreshButton: UIButton?
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView?
	
	var listOfRestaurants: [Restaurant]?
	let locationManager = CLLocationManager()
	var postalCode = ""
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		tableView?.rowHeight = UITableViewAutomaticDimension
		tableView?.estimatedRowHeight = 171
		
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
		startActivity()
	}
	
	func startActivity() {
		activityIndicator?.startAnimating()
		activityIndicator?.alpha = 1
	}
	
	func stopActivity() {
		activityIndicator?.stopAnimating()
		activityIndicator?.alpha = 0
	}
	
	@IBAction func refreshButtonDidTap(refreshButton: UIButton)
	{
		locationManager.startUpdatingLocation()
		startActivity()
	}
	
	func searchRestaurants(postCode: String) {
		if let request = RequestFactory.getRestarauntsRequest(postcode: postCode) {
			Alamofire.request(request)
				.validate()
				.responseJSON { response in
					guard response.result.isSuccess else {
						self.stopActivity()
						return
					}
					
					if let value = response.result.value as? [String: Any]
					{
						DispatchQueue.global(qos: .userInitiated).async {
							let restaurants = value["Restaurants"] as! [[String: Any]]
							self.listOfRestaurants = Restaurant.restaurants(from: restaurants)
							DispatchQueue.main.async {
								self.stopActivity()
								self.tableView?.reloadData()
							}
						}
					}
			}
		}
	}
}

extension RestaurantsListController: CLLocationManagerDelegate {
	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		CLGeocoder().reverseGeocodeLocation(manager.location!,
											completionHandler: {(placemarks, error)-> Void in
												if error != nil {
													self.stopActivity()
													return
												}
												
												if (nil != placemarks)
												{
													if (placemarks?.count)! > 0 {
														let placemark = placemarks![0]
														self.locationManager.stopUpdatingLocation()
														self.postalCode = (placemark.postalCode != nil) ? placemark.postalCode! : ""
														self.searchRestaurants(postCode: self.postalCode)
													}else{
														self.stopActivity()
													}
												}
		})
	}
	
	public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		stopActivity()
	}
}

extension RestaurantsListController: UITableViewDelegate {
	
}

extension RestaurantsListController: UITableViewDataSource {
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		guard listOfRestaurants != nil else {
			return 0
		}
		
		return listOfRestaurants!.count;
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.restaurantCellID, for: indexPath) as! RestaurantCell
		
		if let restaurant = listOfRestaurants?[indexPath.row] {
			cell.nameLabel?.text = restaurant.name
			cell.typesOfFoodLabel?.text = restaurant.cuisineTypes.flatMap({$0})?.joined(separator: "\n")
			
			cell.logoImageView?.image = restaurant.logo
			if let rating = restaurant.rating {
				cell.ratingLabel?.text = rating + "*"
			}
		}
		
		return cell
	}
}
