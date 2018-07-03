//
//  Sort.swift
//  ElasticSearch
//
//  Created by Yaroslav Erohin on 31.01.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

/// Sorting direction.
public enum ElasticDirection:String {
	case ascending = "asc",
	descending = "desc"
}

/// Object to set up sorting in a search query.
public struct ElasticSort {
	private	init() {}

	/// Dictionary to use in the query.
	public private(set) var dict:[String:[String:Any]] = [:]

	/// Returns an empty filter.
	public static var empty:ElasticSort {
		return ElasticSort()
	}

	/// Field type.
	public enum UnmappedType:String {
		case long = "long",
		double = "double",
		boolean = "bool",
		date = "date",
		string = "keyword"
	}

	/**
	Create object that will set up sorting parameters for an elastic search query.

	- Parameters:
		- field: field to sort on.
		- direction: sorting direction.
		- unmappedType: if the field is unmapped, method of sorting needs to be explicitly specified.
		More info here:
		https://www.elastic.co/guide/en/elasticsearch/reference/current/search-request-sort.html#_ignoring_unmapped_fields
	*/
	public init(by field:String,
		 _ direction:ElasticDirection = .descending,
		 unmappedType:UnmappedType? = nil) {
		var dField = [String:Any]()
		dField["order"] = direction.rawValue
		if let type = unmappedType {
			dField["unmapped_type"] = type.rawValue
		}
		dict[field] = dField
	}
}
