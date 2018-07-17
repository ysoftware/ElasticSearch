//
//  Networking.swift
//  ElasticSearch
//
//  Created by Yaroslav Erohin on 03.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

enum HTTPError: LocalizedError {
	
	case malformedUrl
	case invalidResponse
	case parsingError(Error)
	case unknown
	
	var errorDescription: String? {
		switch self {
		case .malformedUrl: return "Malformed URL"
		case .invalidResponse: return "Empty Response"
		case .parsingError(let error): return "Parsing Error \(error.localizedDescription)"
		case .unknown: return "Unknown error"
		}
	}
}

typealias HTTPResponse = (bodyString:String, data:[String:Any])

struct HTTP {
	
	static func post(to urlString:String,
					 parameters:[String:Any] = [:],
					 completion: @escaping (_ result:Result<HTTPResponse>)->Void) {
		
		guard let url = URL(string: urlString) else {
			return completion(.error(HTTPError.malformedUrl))
		}
		
		let body = try! JSONSerialization.data(withJSONObject: parameters,
											   options: .prettyPrinted)
		let session = URLSession.shared
		var request = URLRequest(url: url)

		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.httpMethod = "POST"
		request.httpBody = body
		
		session.dataTask(with: request as URLRequest) { data, _, error in

			if let error = error {
				return completion(.error(error))
			}
			
			guard let data = data,
				let body = String(data: data, encoding: .utf8)
				else {
					return completion(.error(HTTPError.invalidResponse))
			}

			let json:Any
			do {
				json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
			}
			catch let error {
				return completion(.error(HTTPError.parsingError(error)))
			}

			guard let object = json as? [String:Any] else {
				return completion(.error(HTTPError.unknown))
			}

			completion(.data((body, object)))
			}.resume()
	}
}
