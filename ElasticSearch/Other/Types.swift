//
//  Types.swift
//  ElasticSearch
//
//  Created by Yaroslav Erohin on 04.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public struct Aggregation {

	public var value:String

	public var count:Int

	public init(_ value:String, _ count:Int) {
		self.value = value
		self.count = count
	}
}

public enum ElasticError: LocalizedError {

	case parsingError

	public var errorDescription: String? {
		switch self {
		case .parsingError: return "Parsing error"
		}
	}
}

public enum Result<T> {

	case data(T)

	case error(Error)
}

public enum Protocol:String {

	case http = "http"

	case https = "https"
}

/// Method of sorting results.
public enum SortingMethod:String {

	case count = "_count"

	case term = "_term"
}

/// Sorting direction.
public enum ElasticDirection:String {

	case ascending = "asc"

	case descending = "desc"
}

/// Field type.
public enum UnmappedType:String {

	case long = "long"

	case double = "double"

	case boolean = "bool"

	case date = "date"

	case string = "keyword"
}
