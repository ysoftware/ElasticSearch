//
//  Types.swift
//  ElasticSearch
//
//  Created by Yaroslav Erohin on 04.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public struct Completion {
	public typealias Hits = ([[String:Any]])->Void
	public typealias Counts = ([(String, Int)])->Void
	public typealias Strings = ([String])->Void
}

public enum Protocol:String {
	case http = "http"
	case https = "https"
}
