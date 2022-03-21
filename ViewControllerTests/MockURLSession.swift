//
//  MockURLSession.swift
//  ViewControllerTests
//
//  Created by Nikola Andrijasevic on 18.3.22..
//
import XCTest
import Foundation
@testable import CodingTaskMobile

class MockURLSession: URLSessionProtocol{
    var dataTaskCallCount = 0
    var dataTaskArgsRequest: [URLRequest] = []
    var dataTaskArgsCompletionHandler: [(Data?,URLResponse?,Error?)->Void] = []
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let request = URLRequest(url: url)
        dataTaskCallCount += 1
        dataTaskArgsRequest.append(request)
        dataTaskArgsCompletionHandler.append(completionHandler)
        return DummyURLSessionDataTask()
    }
    
    func verifyDataTask(with request: URLRequest,file: StaticString = #file, line: UInt = #line){
        XCTAssertEqual(dataTaskCallCount, 1, "call count", file: file, line: line)
        XCTAssertEqual(dataTaskArgsRequest.first, request, "request",
                       file: file, line: line)
    }//file and line argument to show error inside test case because they capture file name and line number where called from
}

private class DummyURLSessionDataTask: URLSessionDataTask{
    override func resume() {
        
    }//dummy object
}
