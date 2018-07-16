//
//  Helper.swift
//  ElasticSearch
//
//  Created by ysoftware on 16.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

protocol ElasticRequest {

	var indexName:String { get }

	var filter:Filter { get }

	var sort:Order { get }

	var page:Int { get }

	var size:Int { get }
}
