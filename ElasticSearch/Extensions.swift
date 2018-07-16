//
//  Extensions.swift
//  ElasticSearch
//
//  Created by Yaroslav Erohin on 03.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

// MARK: - Special function to print debug information on requests

internal enum DebugOperation { case requesting, receiving }

internal func _debugPrint(_ op:DebugOperation,
						  _ name:String,
						  _ url:String,
						  _ body:String) {

	let sending = op == .requesting
	let arrow = sending ? "->" : "<-"
	let operation = sending ? "Requesting" : "Receiving"
	let word = sending ? "at" : "from"

	print("""
		\(arrow) \(operation) \(name) \(word): \(url)
		\(body)
		""")
}

internal extension Dictionary {

	var jsonString:String {
		do {
			let data = try JSONSerialization.data(withJSONObject: self as AnyObject,
												  options: .prettyPrinted)
			return String(data: data, encoding: .utf8)
				?? "<Error: Could not convert json data to string.>"
		}
		catch let error {
			return "<Error: Could not encode this dictionary: (\(error)>"
		}
	}
}

internal extension CharacterSet {

	var characters:[String] {
		var chars = [String]()
		for plane:UInt8 in 0...16 {
			if hasMember(inPlane: plane) {
				let p0 = UInt32(plane) << 16
				let p1 = (UInt32(plane) + 1) << 16
				for c:UTF32Char in p0..<p1 {
					if (self as NSCharacterSet).longCharacterIsMember(c) {
						var c1 = c.littleEndian
						let s = NSString(bytes: &c1, length: 4,
										 encoding: String.Encoding.utf32LittleEndian.rawValue)!
						chars.append(String(s))
					}
				}
			}
		}
		return chars
	}
}

internal extension String {
	
	func trim() -> String {
		return trimmingCharacters(in: .whitespacesAndNewlines)
	}

	func replacingCharacters(from sets:[CharacterSet], with new:String) -> String {
		return replacingCharacters(from: sets.map { $0.characters.joined() }.joined(), with: new)
	}

	func replacingCharacters(from set:CharacterSet, with new:String) -> String {
		return replacingCharacters(from: set.characters.joined(), with: new)
	}

	func replacingCharacters(from set:String, with new:String) -> String {
		var output = self
		for s in set {
			output = output.replacingOccurrences(of: String(s), with: new)
		}
		return output
	}
}
