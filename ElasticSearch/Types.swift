//
//  Types.swift
//  ElasticSearch
//
//  Created by Yaroslav Erohin on 04.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public enum ElasticError: LocalizedError {

	case parsingError

	public var errorDescription: String? {
		switch self {
		case .parsingError: return "Parsing error"
		}
	}
}

public struct Completion {

	public typealias Hits = (Result<[[String:Any]]>)->Void

	public typealias Counts = (Result<[(String, Int)]>)->Void

	public typealias Strings = (Result<[String]>)->Void
}

public enum Result<T> {

	case data(T)

	case error(Error)
}

public enum Protocol:String {

	case http = "http"

	case https = "https"
}
