//
//  Aggregator.swift
//  ElasticSearch
//
//  Created by Yaroslav Erohin on 31.01.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

/// Object to set up an aggregation query.
public struct Aggregator {

	private	init() {}

	/// Dictionary to use in the query.
	public internal(set) var dict:[String:Any] = [:]

	/// Name of the json object that will hold the results.
	internal static let valuesName = "values"
}

public extension Aggregator {
	
	/// Create an object that will set up aggregation query with required parameters.
	///
	/// - Parameters:
	///   - field: field to aggregate.
	///   - order: method of ordering results.
	///   - direction: sorting direction.
	///   - count: minumum number of documents with the same value to be included in results.
	///   - limit: maximum number of results.
	public init(_ field: String,
		 orderBy order:SortingMethod? = nil,
		 _ direction: ElasticDirection = .descending,
		 minimumDocumentsCount count:UInt? = nil,
		 limit: UInt? = nil) {

		var dParams:[String:Any] = [:]
		dParams["field"] = field

		if let count = count { dParams["min_doc_count"] = count }
		if let limit = limit { dParams["size"] = limit }

		if let order = order {
			var dOrder:[String:String] = [:]
			dOrder[order.rawValue] = direction.rawValue
			dParams["order"] = dOrder
		}

		var dTerms:[String:Any] = [:]
		dTerms["terms"] = dParams

		var dValues:[String:Any] = [:]
		dValues[Aggregator.valuesName] = dTerms

		dict["aggs"] = dValues
		dict["size"] = 0
	}
}
