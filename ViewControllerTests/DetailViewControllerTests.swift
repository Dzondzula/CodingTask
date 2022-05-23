//
//  DetailViewControllerTests.swift
//  ViewControllerTests
//
//  Created by Nikola Andrijasevic on 23.5.22..
//

import XCTest
@testable import CodingTaskMobile

class DetailViewControllerTests: XCTestCase {

    var sut: DetailViewController!
    
 let apiURL = URL(string: "https://api.github.com/repos/octocat/boysenberry-repo-1/commits")!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
         sut = storyboard.instantiateViewController(
        identifier: "DetailViewController")
        sut.loadViewIfNeeded()
            
    #if DEBUG
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [MockURLProtocol.self]
            let urlSession = URLSession.init(configuration: configuration)
    #else
            let urlSession = URLSession.shared
    #endif
            sut = DetailViewController(urlSession: urlSession)
           
            MockURLProtocol.clear()
        }
   
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_OutletsShouldBeConnected(){
        XCTAssertNotNil(sut.descriptionLabel)
      
    }
    func test_fetchMethodShouldFill_countriessArrayAndAskQuestion(){
        
        let  expectation = expectation(description: "wait")
        
        let data = jsonData()
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == self.apiURL else {
                throw MyError.noData
            }
            let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        sut.getCommits { (result) in
            switch result{
            case .success(let post):
                XCTAssertNotNil(post)
                
            case.failure(let error):
                XCTFail("Error was not expected: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertEqual(sut.gitCommits, nil)
        
       
    }
    
    private func jsonData() -> Data {
            """
    [
      {
       "commit": {
          "author": {
            "name": "Jessica Canepa"
          },
          "message": "Set theme: \"jekyll-theme-minimal\" in _config.yml."
          },
        "committer": {
          "avatar_url": "https://avatars.githubusercontent.com/u/6732600?v=4"
        }
      }]
    """.data(using: .utf8)!
        }
    
    enum MyError: Error{
        case noData
    }

}

