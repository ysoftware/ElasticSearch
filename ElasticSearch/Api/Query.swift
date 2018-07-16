//
//  Query.swift
//  ElasticSearch
//
//  Created by ysoftware on 16.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public protocol Query {

	var indexName:String { get }

	var filter:Filter { get }

	var orders:[Order] { get }

	var page:UInt? { get }

	var size:UInt { get }
}
