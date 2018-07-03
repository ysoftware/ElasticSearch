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
	let testUrlCorrupt = ""

	func testNetwork() {
		let expect = XCTestExpectation(description: "loading")
		HTTP.post(to: testUrl) { result in
			if result.count > 0 {
				expect.fulfill()
			}
			else {
				XCTAssert(false, "Network: result data is corrupt")
			}
		}
		wait(for: [expect], timeout: 10)
	}

	func testNetworkEmpty() {
		let expect = XCTestExpectation(description: "loading")
		HTTP.post(to: testUrlEmpty) { result in
			if result.count == 0 {
				expect.fulfill()
			}
			else {
				XCTAssert(false, "Network: should have failed")
			}
		}
		wait(for: [expect], timeout: 10)
	}

	func testNetworkFail() {
		let expect = XCTestExpectation(description: "loading")
		HTTP.post(to: testUrlFail) { result in
			if result.count == 0 {
				expect.fulfill()
			}
			else {
				XCTAssert(false, "Network: should have failed")
			}
		}
		wait(for: [expect], timeout: 10)
	}

	func testNetworkUrlCorrupt() {
		let expect = XCTestExpectation(description: "loading")
		HTTP.post(to: testUrlCorrupt) { result in
			if result.count == 0 {
				expect.fulfill()
			}
			else {
				XCTAssert(false, "Network: should have failed")
			}
		}
		wait(for: [expect], timeout: 10)
	}
}
