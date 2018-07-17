//
//  UnmappedType.swift
//  ElasticSearch
//
//  Created by ysoftware on 17.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

/// Field type.
public enum UnmappedType:String {

	case long = "long"

	case double = "double"

	case boolean = "bool"

	case date = "date"

	case string = "keyword"
}
