//
//  Aggregator.swift
//  ElasticSearch
//
//  Created by Yaroslav Erohin on 31.01.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

/// Method of sorting results.
public enum SortingMethod:String {
	case count = "_count",
	term = "_term"
}

/// Object to set up an aggregation query.
public struct ElasticAggregator {
	private	init() {}

	/// Dictionary to use in the query.
	public private(set) var dict:[String:Any] = [:]

	/// Name of the json object that will hold the results.
	public static let valuesName = "values"

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
		dValues[ElasticAggregator.valuesName] = dTerms

		dict["aggs"] = dValues
		dict["size"] = 0
	}
}
