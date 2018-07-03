//
//  Networking.swift
//  ElasticSearch
//
//  Created by Yaroslav Erohin on 03.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct HTTP {

	static func post(to urlString:String,
					 parameters:[String:Any] = [:],
					 completion: @escaping ([String:Any])->Void) {

		guard let url = URL(string: urlString) else {
			return completion([:])
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
			if let data = data,
				let json = try? JSONSerialization.jsonObject(with: data,
															 options: .mutableContainers),
				let object = json as? [String: Any] {
				return completion(object)
			}

			print(error?.localizedDescription ?? "HTTP dataTask unknown error")
			completion([:])
			}.resume()
	}
}
