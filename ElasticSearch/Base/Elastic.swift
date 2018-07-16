//
//  Elastic.swift
//  ElasticSearch
//
//  Created by Yaroslav Erohin on 27.01.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public struct Elastic {

	/// Public initializer.
	///
	/// - Parameter configuration: configuration object.
	public init(with configuration:Configuration) {
		self.configuration = configuration
	}

	/// Configuration object for elastic search requests.
	public let configuration:Configuration
}
