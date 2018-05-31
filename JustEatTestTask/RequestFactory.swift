//
//  RequestPerformer.swift
//  JustEatTestTask
//
//  Created by Alexander Chulanov on 5/29/18.
//  Copyright © 2018 Alexander Chulanov. All rights reserved.
//

import Foundation

class RequestFactory
{	
	static func getRestarauntsRequest(postcode: String) -> URLRequest? {
		guard let url = URL(string: "https://public.je-apis.com/restaurants?q=\(postcode)") else {
			return nil
		}
		let headers = ["Accept-Tenant": "uk",
					   "Accept-Language": "en-GB",
					   "Authorization": "Basic VGVjaFRlc3Q6bkQ2NGxXVnZreDVw",
					   "Host": "public.je-apis.com"]
		
		do {
			let request = try URLRequest(url: url, method: .get, headers: headers)
			
			return request
		}
		catch {
			return nil
		}
	}
}
