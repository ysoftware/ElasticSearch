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
