//
//  Configuration.swift
//  ElasticSearch
//
//  Created by ysoftware on 16.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

/// List of settings for Elastic object.
public class ElasticConfiguration {

	/// Enables debug print of all json data sent and received.
	public var debugPrintResponseBody = false

	/// Enables debug print of all json data sent and received.
	public var debugPrintRequestBody = false

	// Url to send requests to.
	public internal(set) var baseUrl:String!
}
