//
//  BaseMethods.swift
//  ElasticSearch
//
//  Created by ysoftware on 16.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public extension Elastic {

	/// Perform search operation.
	///
	/// - Parameters:
	///   - index: index in which the query is performed.
	///   - query: Object of type `Filter` that sets up required parameters.
	///   - sort: array of `Order` objects to sort results.
	///   - page: request cursor for pagination. `size` is also required.
	///   - size: limit of result elements.
	///   - completion: Block with array of found dictionary objects
	///     that will run after search query is complete.
	///		If request fails, empty array is returned.
	public func search(_ index:String,
					   query:Filter = .empty,
					   sort:[Order] = [],
					   page:UInt? = nil,
					   size:UInt? = nil,
					   completion: @escaping (Result<[[String:Any]]>)->Void) {

		guard let baseUrl = configuration.baseUrl else {
			fatalError("You did not call Elastic.configure(...) method")
		}

		let url = "\(baseUrl)/\(index)/_search?pretty"

		var params:[String:Any] = [:]

		if query.dict.count > 0 {
			params["query"] = query.dict
		}

		if sort.count > 0 {
			params["sort"] = sort.map { $0.dict }
		}

		if let size = size {
			params["size"] = size
			if let page = page { params["from"] = page * size }
		}

		_debugPrint(.requesting, "search results", url, params.jsonString)

		HTTP.post(to: url,
				  parameters: params) { result in

					switch result {
					case .error(let error):
						completion(.error(error))
					case .data(let result):
						self._debugPrint(.receiving, "search results", url, result.bodyString)

						guard let hitsResponse = result.data["hits"] as? [String: Any],
							let hits = hitsResponse["hits"] as? [[String: Any]]
							else {
								return completion(.error(ElasticError.parsingError))
						}

						let items = hits.compactMap { $0["_source"] as? [String: Any] }

						DispatchQueue.main.async {
							completion(.data(items))
						}
					}
		}
	}

	/// Aggregate different values of the specified field.
	///
	/// - important: The field has to be of type `keyword`.
	/// More info at: https://www.elastic.co/guide/en/elasticsearch/reference/master/keyword.html
	///
	/// - Parameters:
	///   - index: index in which the query is performed.
	///   - query: Object of type `Aggregator` that sets up required parameters.
	///   - completion: Block with array of results that will run after query is complete.
	///     If request fails, empty array is returned.
	public func aggregate(_ index:String,
						  with query:Aggregator,
						  completion: @escaping (Result<[Aggregation]>)->Void) {
		guard let baseUrl = configuration.baseUrl else {
			fatalError("You did not call Elastic.configure(...) method")
		}

		let url = "\(baseUrl)/\(index)/_search?pretty"
		let params = query.dict

		_debugPrint(.requesting, "aggregations", url, params.jsonString)

		HTTP.post(to: url,
				  parameters: params) { result in

					switch result {
					case .error(let error):
						completion(.error(error))
					case .data(let result):
						self._debugPrint(.receiving, "aggregations", url, result.bodyString)

						guard
							let aggregations = result.data["aggregations"] as? [String: Any],
							let values = aggregations[Aggregator.valuesName] as? [String: Any],
							let buckets = values["buckets"] as? [[String: Any]]
							else {
								return completion(.error(ElasticError.parsingError))
						}

						let items:[Aggregation] = buckets.compactMap { data in
							guard let key = data["key"] as? String,
								let count = data["doc_count"] as? Int
								else { return nil }
							return Aggregation(key, count)
						}

						DispatchQueue.main.async {
							completion(.data(items))
						}
					}
		}
	}

	/// Request a list of suggestions to complete the search query.
	///
	///	- important: The field has to be of type `completion`.
	///
	/// - Parameters:
	///   - index: index in which the query is performed.
	///   - query: Object of type `Aggregator` that sets up required parameters.
	///   - field: the property to perform search on.
	///   - completion: Block with list of suggestions to complete the query.
	///     If request fails, empty array is returned.
	public func suggestCompletions(_ index:String,
								   for query:String,
								   field:String,
								   _ completion: @escaping (Result<[String]>)->Void) {
		guard let baseUrl = configuration.baseUrl else {
			fatalError("You did not call Elastic.configure(...) method")
		}

		let url = "\(baseUrl)/\(index)/_search?pretty"
		let params:[String:Any] = ["_source": [field],
								   "suggest":
									["results":
										["prefix": query,
										 "completion": ["field":field,
														"skip_duplicates":true]]]]

		_debugPrint(.requesting, "suggest completions", url, params.jsonString)

		HTTP.post(to: url,
				  parameters: params) { result in

					switch result {
					case .error(let error):
						completion(.error(error))
					case .data(let result):
						self._debugPrint(.receiving, "suggest completions", url, result.bodyString)

						guard
							let suggest = result.data["suggest"] as? [String:Any],
							let results = suggest["results"] as? [[String:Any]],
							let options = results.first?["options"] as? [[String:Any]]
							else {
								return completion(.error(ElasticError.parsingError))
						}

						let optionsSource = options.compactMap { $0["_source"] }
						guard let sources = optionsSource as? [[String:String]] else {
							return completion(.error(ElasticError.parsingError))
						}

						let names = sources.compactMap { $0["name"] }

						DispatchQueue.main.async {
							completion(.data(names))
						}
					}
		}
	}
}
