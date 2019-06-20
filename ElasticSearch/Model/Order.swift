//
//  Order.swift
//  ElasticSearch
//
//  Created by Yaroslav Erohin on 31.01.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

/// Object to set up sorting in a search query.
public struct Order {

	private	init() {}

	/// Dictionary to use in the query.
	public internal(set) var dict:[String:[String:Any]] = [:]

	/// Returns an empty filter.
	public static var empty:Order { return .init() }
}

public extension Order {

	/// Create object that will set up sorting parameters for an elastic search query.
	///
	/// - Parameters:
	///	  - field: field to sort on.
	///	  - direction: sorting direction.
	///	  - unmappedType: if the field is unmapped, sorting method has to be explicitly specified.
	///	  More info here:
	///	  https://www.elastic.co/guide/en/elasticsearch/reference/current/
	///   search-request-sort.html#_ignoring_unmapped_fields
	public init(by field:String,
		 _ direction:ElasticDirection = .descending,
		 unmappedType:UnmappedType? = nil,
         mode: String? = nil, inPath: String? = nil) {
		var dField = [String:Any]()
		dField["order"] = direction.rawValue
		if let type = unmappedType {
			dField["unmapped_type"] = type.rawValue
		}
        if let mode = mode {
            guard let inPath = inPath else { return }
            dField["mode"] = mode
            var nestedField = [String:Any]()
            nestedField["path"] = inPath
            dField["nested"] = nestedField
        }
		dict[field] = dField
	}
    
}
