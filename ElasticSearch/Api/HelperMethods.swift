//
//  HelperMethods.swift
//  ElasticSearch
//
//  Created by ysoftware on 16.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public extension Elastic {

	func search<T:Codable>(_ query:Query, completion: @escaping (Result<[T]>)->Void) {
		search(query.indexName,
			   query: query.filter,
			   sort: query.orders,
			   page: query.page,
			   size: query.size) { result in

				switch result {
				case .data(let result):
					completion(.data(result.parse()))
				case .error(let error):
					completion(.error(error))
				}
		}
	}
}
