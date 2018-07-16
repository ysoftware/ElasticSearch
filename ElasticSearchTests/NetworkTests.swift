//
//  NetworkTests.swift
//  ElasticSearchTests
//
//  Created by ysoftware on 03.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import XCTest
@testable import ElasticSearch

class NetworkTests: XCTestCase {

	let testUrl = "https://jsonplaceholder.typicode.com/posts"
	let testUrlEmpty = "https://jsonplaceholder.typicode.com/post"
	let testUrlFail = "http://ysoftware.ru/doctorwho/ENnews.xml"
	let testUrlInvalid = "invalid url"

	func testNetworkSuccess() {
		let expect = XCTestExpectation(description: "loading")
		HTTP.post(to: testUrl) { result in
			switch result {
			case .data(let result):
				if !result.data.isEmpty {
					expect.fulfill()
				}
				else {
					XCTFail("Should have succeeded")
				}
			case .error(let error):
				XCTFail("\(error.localizedDescription)")
			}
		}
		wait(for: [expect], timeout: 10)
	}

	func testNetworkEmptyResult() {
		let expect = XCTestExpectation(description: "loading")
		HTTP.post(to: testUrlEmpty) { result in
			switch result {
			case .data(let result):
				if result.data.isEmpty {
					expect.fulfill()
				}
				else {
					XCTFail("Should have failed")
				}
			case .error(let error):
				XCTFail("\(error.localizedDescription)")
			}
		}
		wait(for: [expect], timeout: 10)
	}

	func testNetworkParseFail() {
		let expect = XCTestExpectation(description: "loading")
		HTTP.post(to: testUrlFail) { result in
			switch result {
			case .data(_):
				XCTFail("Should have failed")
			case .error(let error):
				switch error {
				case HTTPError.parsingError(_): expect.fulfill()
				default: XCTFail("Incorrect error: \(error.localizedDescription)")
				}
			}
		}
		wait(for: [expect], timeout: 10)
	}

	func testNetworkUrlInvalid() {
		let expect = XCTestExpectation(description: "loading")
		HTTP.post(to: testUrlInvalid) { result in
			switch result {
			case .data(_):
				XCTFail("Should have failed")
			case .error(let error):
				switch error {
				case HTTPError.malformedUrl: expect.fulfill()
				default: XCTFail("Incorrect error: \(error.localizedDescription)")
				}
			}
		}
		wait(for: [expect], timeout: 10)
	}
}
