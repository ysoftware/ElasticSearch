//
//  Result.swift
//  ElasticSearch
//
//  Created by ysoftware on 17.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public enum Result<T> {

	case data(T)

	case error(Error)
}
