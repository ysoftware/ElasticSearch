//
//  Codable.swift
//  FirestoreHelper
//
//  Created by Yaroslav Erohin on01.10.2017.
//  Copyright © 2017 Ysoftware. All rights reserved.
//

import Foundation

public extension Decodable {

	/// Инициализовать объект Decodable с помощью Dictionary.
	public init?(_ dict:Any?) {
		guard let dict = dict else { return nil }

		do {
			let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
			self = try JSONDecoder().decode(Self.self, from: data)
		}
		catch {
			print("decodable init: \(error)")
			return nil
		}
	}
}

public extension Encodable {

	/// Преобразовать объект Encodable в Dictionary.
	public func toDictionary() -> [String:Any] {
		do {
			let data = try JSONEncoder().encode(self)
			let value = try JSONDecoder().decode(JSONAny.self, from: data)
			if let value_ = value.value as? [String:Any] {
				return value_
			}
			else {
				print("encodable.asDict: something went wrong and needs debugging")
				return [:]
			}
		}
		catch let error {
			print("encodable.asDict: \(error)")
			return [:]
		}
	}
}

public extension Dictionary where Key == String {

	/// Преобразовать в объект.
	/// - Parameter class: класс объекта.
	func parse<T:Decodable>(object class:T.Type = T.self) -> T? {
		do {
			let data = try JSONSerialization.data(withJSONObject: self)
			return try JSONDecoder().decode(T.self, from: data)
		}
		catch {
			print("search: parse \(T.self): \(error)")
			return nil
		}
	}
}

public extension Array where Element == Dictionary<String, Any> {

	/// Преобразовать в объект.
	/// - Parameter class: класс объекта.
	func parse<T:Decodable>(arrayOf class:T.Type = T.self) -> [T] {
		do {
			let data = try JSONSerialization.data(withJSONObject: self)
			return try JSONDecoder().decode([T].self, from: data)
		}
		catch {
			print("search: parse arrayOf \(T.self): \(error)")
			return []
		}
	}

}

