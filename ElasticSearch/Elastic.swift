//
//  Elastic.swift
//  ElasticSearch
//
//  Created by Yaroslav Erohin on 27.01.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public struct Completion {
	public typealias Hits = ([[String:Any]])->Void
	public typealias Counts = ([(String, Int)])->Void
	public typealias Strings = ([String])->Void
}

public struct Elastic {
	private init() {}

	public static var BASEURL:String!
	public static var PRINT_DEBUG = false

	/// Configure all future requests for elastic search.
	public static func configure(at host:String, port:String = "9200") {
		BASEURL = "http://\(host):\(port)"
	}

	/// Perform search operation
	///
	/// - Parameters:
	///   - index: index in which the query is performed.
	///   - query: Object of type `ElasticFilter` that sets up required parameters.
	///   - sort: array of `ElasticSort` objects to sort results.
	///   - page: request cursor for pagination. `size` is also required.
	///   - size: limit of result elements.
	///   - completion: Block with array of hits that will run after search query is complete.
	///		If request fails, empty array is returned.
	public static func search(_ index:String,
							  query:ElasticFilter = .empty,
							  sort:[ElasticSort] = [],
							  page:UInt? = nil,
							  size:UInt? = nil,
							  completion: @escaping Completion.Hits) {
		let url = "\(Elastic.BASEURL!)/\(index)/_search?pretty"

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

		if PRINT_DEBUG {
			print(url)
			print(params.jsonString)
		}

		HTTP.post(to: url,
				  parameters: params) { result in
					if PRINT_DEBUG {
						print(result.jsonString)
					}
					guard
						let hitsResponse = result["hits"] as? [String: Any],
						let hits = hitsResponse["hits"] as? [[String: Any]]
						else { return completion([]) }

					DispatchQueue.main.async {
						completion(hits.compactMap { $0["_source"] as? [String: Any] ?? [:] })
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
	///   - query: Object of type `ElasticAggregator` that sets up required parameters.
	///   - completion: Block with array of results that will run after query is complete.
	///     If request fails, empty array is returned.
	public static func aggregate(_ index:String,
								 with query:ElasticAggregator,
								 completion: @escaping Completion.Counts) {
		let url = "\(Elastic.BASEURL!)/\(index)/_search?pretty"

		if PRINT_DEBUG {
			print(url)
			print(query.dict.jsonString)
		}

		HTTP.post(to: url,
				  parameters: query.dict) { result in
					if PRINT_DEBUG {
						print(result.jsonString)
					}
					guard
						let aggregations = result["aggregations"] as? [String: Any],
						let values = aggregations[ElasticAggregator.valuesName] as? [String: Any],
						let buckets = values["buckets"] as? [[String: Any]]
						else { return completion([]) }
					DispatchQueue.main.async {
						completion(buckets.compactMap { data in
							guard let key = data["key"] as? String,
								let count = data["doc_count"] as? Int
								else { return nil }
							return (key, count)
						})
					}
		}
	}

	/// Request a list of suggestions to complete the search query.
	///
	///	- important: The field has to be of type `completion`.
	///
	/// - Parameters:
	///   - index: index in which the query is performed.
	///   - query: Object of type `ElasticAggregator` that sets up required parameters.
	///   - field: the property to perform search on.
	///   - completion: Block with list of suggestions to complete the query.
	///     If request fails, empty array is returned.
	public static func suggestCompletions(_ index:String,
										  for query:String,
										  field:String,
										  _ completion: @escaping Completion.Strings) {
		let url = "\(Elastic.BASEURL!)/\(index)/_search?pretty"
		let params:[String:Any] = ["_source":[field],
								   "suggest": ["results": ["prefix":query,
														   "completion": ["field":field,
																		  "skip_duplicates":true]]]]

		if PRINT_DEBUG {
			print(url)
			print(params.jsonString)
		}

		HTTP.post(to: url,
				  parameters: params) { result in
					if PRINT_DEBUG {
						print(result.jsonString)
					}
					guard
						let suggest = result["suggest"] as? [String:Any],
						let results = suggest["results"] as? [[String:Any]],
						let options = results.first?["options"] as? [[String:Any]]
						else { return completion([]) }

					let optionsSource = options.compactMap { $0["_source"] }
					guard let sources = optionsSource as? [[String:String]] else {
						return completion([])
					}
					let names = sources.compactMap { $0["name"] }
					DispatchQueue.main.async {
						completion(names)
					}
		}
	}
}
