//
//  Error.swift
//  ElasticSearch
//
//  Created by ysoftware on 17.07.2018.
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
