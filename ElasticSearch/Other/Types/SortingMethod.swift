//
//  SortingMethod.swift
//  ElasticSearch
//
//  Created by ysoftware on 17.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

/// Method of sorting results.
public enum SortingMethod:String {

	case count = "_count"

	case term = "_term"
}
