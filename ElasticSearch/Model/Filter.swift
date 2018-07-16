//
//  Filter.swift
//  ElasticSearch
//
//  Created by Yaroslav Erohin on 30.01.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

/// Object to set up a search query.
public struct Filter {

	private	init() {}

	/// Dictionary to use in the query.
	public internal(set) var dict:[String:Any] = [:]

	/// Returns an empty filter.
	public static var empty:Filter { return .init() }
}

public extension Filter {

	// MARK: - Compound

	/// Create a new compound filter to match all of the filters in the array. (AND)
	///
	/// - Parameter filters: filters to merge in this compound filter.
	public init(matchAll filters:[Filter]) {
		let filters = filters.filter { !$0.dict.isEmpty }
		guard !filters.isEmpty else { return }
		var dBool = [String:Any]()
		dBool["must"] = filters.map { $0.dict }.filter { !$0.isEmpty }
		dict["bool"] = dBool
	}

	/// Create a new compound filter to match some of the filters in the array.
	///
	/// - Parameters:
	///   - filters: filters to merge in this compound filter.
	///   - minimum: number of filters that are required to be matched.
	///     Default is 1, which means it will work as the standard OR.
	public init(matchSome filters:[Filter], atLeast minimum:UInt = 1) {
		let filters = filters.filter { !$0.dict.isEmpty }
		guard !filters.isEmpty else { return }
		var dBool = [String:Any]()
		dBool["should"] = filters.map { $0.dict }
		dBool["minimum_should_match"] = minimum
		dict["bool"] = dBool
	}

	/// Create a compound filter that will look for documents
	/// in which the specified field matches one of the values in the array.
	///
	/// - Parameters:
	///   - field: field to match.
	///   - values: array of values to look.
	public init(matchField field:String, to values:[String]) {
		var filters:[Filter] = []
		values.forEach { value in
			filters.append(Filter(matching: field, to: value))
		}
		self.init(matchSome: filters, atLeast: 1)
	}

	/// Create a new filter including another filter as nested.
	///
	/// - important: Paths to properties inside a nested filter should be specified fully.
	///	Example: "beers.beerId".
	///
	/// - Parameters:
	///   - filter: a filter to include as nested.
	///   - path: path to the nested property.
	public init(nested filter:Filter, in path:String) {
		var dNested = [String:Any]()
		dNested["path"] = path
		dNested["query"] = filter.dict
		dict["nested"] = dNested
	}

	// MARK: - Single

	/// Create a filter that will match the specified field to the value.
	///
	/// - Parameters:
	///   - field: field to match.
	///   - value: value to look for.
	public init(matching field:String, to value:String) {
		dict["match"] = [field:value]
	}

	/// Create a filter that will perform a wildcard search on the specified field.
	///
	/// - Parameters:
	///   - field: field to match.
	///   - string: query to look for. Adding wildcard characters is not required.
	public init(searching field:String, query string:String) {
		let query = string
			.trimmingCharacters(in: .whitespacesAndNewlines)
			.replacingCharacters(from: "0123456789!’`'-%#&(),.\"", with: " ")
			.replacingOccurrences(of: " ", with: "*")
		dict["wildcard"] = [field:"*\(query.lowercased())*"]
	}

	/// Create a filter that will find elements with specified field starting with given query.
	///
	/// - Parameters:
	///   - field: field to match.
	///   - string: query to look for.
	public init(field:String, startingWith string:String) {
		let query = string.trimmingCharacters(in: .whitespacesAndNewlines)
		dict["wildcard"] = [field:"\(query.lowercased())*"]
	}

	/// Create a filter that will perform a range search on the specified field.
	///
	/// - Parameters:
	///   - field: field to match.
	///   - from: minimum value.
	///   - includeFrom: should results include values of field that equal the minimum value.
	///   - to: maximum value.
	///   - includeTo: should results include values of field that equal the maximum value.
	public init(withRangeOf field:String,
				from:Double? = nil, inclusive includeFrom:Bool = true,
				to:Double? = nil, inclusive includeTo:Bool = true) {

		guard from != nil || to != nil else { return }

		let fromMethod = includeFrom ? "gte" : "gt"
		let toMethod = includeTo ? "lte" : "lt"

		var dRange = [String:Any]()
		var dField = [String:Any]()

		if let from = from { dField[fromMethod] = from }
		if let to = to { dField[toMethod] = to }

		dRange[field] = dField
		dict["range"] = dRange
	}

	/// Speed performs "plane" search method, precision uses "arc".
	/// Plane is faster, but inaccurate on long distances and close to the poles.
	public enum GeoSearchMethod:String {
		/// Faster but less accurate on long distances.
		case speed = "plane"
		/// More accurate on longer distances but overall slower.
		case precision = "arc"
	}

	/// Create a filter that will perform a search for points around.
	///
	/// For more info follow this link:
	/// https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-geo-distance-query.html
	///
	/// - Parameters:
	///   - distance: distance around the point to look for results (in meters).
	///   - latitude: latitude coordinate of the point.
	///   - longitude: longitude coordinate of the point.
	///   - locationField: name of the location property in the document.
	///   - method: name of the location property in the document.
	init(metersAround distance:UInt,
		 latitude:Double, longitude:Double,
		 locationField:String = "location",
		 method:GeoSearchMethod = .speed) {

		dict["geo_distance"] = [
			locationField 	: "\(latitude),\(longitude)",
			"distance_type" : method.rawValue,
			"distance" 		: "\(distance)m"
		]
	}
}
